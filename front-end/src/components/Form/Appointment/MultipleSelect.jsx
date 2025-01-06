import React, { useState, useEffect } from "react";
import { FaSearch, FaChevronDown } from "react-icons/fa";
import { FaXmark } from "react-icons/fa6";
const MultipleSelect = ({
  // Core props
  options = [],                    // Array of options
  value = "",                      // Selected value
  onChange,                        // Callback when value changes
  
  // Display props
  placeholder = "Chọn tuỳ chọn",   // Placeholder text
  displayKey = "label",           // Key to display from option object (if options are objects)
  valueKey = "value",             // Key to use as value (if options are objects)
  
  // Customization props
  className = "",                 // Container className
  width = "w-full",              // Width of the select
  maxHeight = "200px",           // Max height of dropdown
  searchPlaceholder = "Tìm kiếm...", // Search input placeholder
  
  // Feature flags
  searchable = true,             // Enable search
  clearable = true,              // Show clear button
  disabled = false,              // Disable the select
  required = false,              // Make the select required
  loading = false,               // Show loading state
  
  // Custom renders
  renderOption,                  // Custom option renderer
  noOptionsMessage = "Không tìm thấy tùy chọn nào"
}) => {
  // States
  const [isActive, setIsActive] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  
  // Get current selected option
  const selectedOption = Array.isArray(options) 
    ? options.find(opt => 
        typeof opt === "object" 
          ? opt[valueKey] === value 
          : opt === value
      )
    : null;

  // Filter options based on search
  const filteredOptions = Array.isArray(options) 
    ? options.filter(option => {
        const label = typeof option === "object" ? option[displayKey] : option;
        return label.toLowerCase().includes(searchQuery.toLowerCase());
      })
    : [];

  // Handle click outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (!event.target.closest(".select-widget")) {
        setIsActive(false);
        setSearchQuery("");
      }
    };

    document.addEventListener("click", handleClickOutside);
    return () => document.removeEventListener("click", handleClickOutside);
  }, []);

  // Handle option selection
  const handleSelect = (option) => {
    const newValue = typeof option === "object" ? option[valueKey] : option;
    onChange?.(newValue);
    setIsActive(false);
    setSearchQuery("");
  };

  // Handle clear
  const handleClear = (e) => {
    e.stopPropagation();
    onChange?.("");
    setSearchQuery("");
  };

  // Get display value
  const getDisplayValue = () => {
    if (!value || !selectedOption) return "";
    return typeof selectedOption === "object" 
      ? selectedOption[displayKey] 
      : selectedOption;
  };

  // Render option
  const renderOptionItem = (option) => {
    if (renderOption) return renderOption(option);
    
    const label = typeof option === "object" ? option[displayKey] : option;
    const optionValue = typeof option === "object" ? option[valueKey] : option;
    
    return (
      <div
        className={`
          py-2 px-4 cursor-pointer transition-colors duration-150
          ${optionValue === value ? "bg-blue-50 text-blue-600" : "hover:bg-gray-50"}
        `}
      >
        {label}
      </div>
    );
  };

  return (
    <div className={`relative select-widget ${width} ${className}`}>
      {/* Main button */}
      <button
        type="button"
        disabled={disabled}
        className={`
          w-full px-3 py-2 flex items-center justify-between gap-2 
          bg-white border rounded-lg transition-colors duration-150
          ${disabled 
            ? "bg-gray-100 cursor-not-allowed" 
            : "hover:border-gray-400"
          }
          ${isActive ? "border-blue-500" : "border-gray-300"}
        `}
        onClick={() => !disabled && setIsActive(!isActive)}
      >
        <span className={`truncate ${!value && "text-gray-500"}`}>
          {getDisplayValue() || placeholder}
        </span>
        
        <div className="flex items-center gap-1">
          {clearable && value && !disabled && (
            <FaXmark
              className="w-4 h-4 text-gray-400 hover:text-gray-600"
              onClick={handleClear}
            />
          )}
          <FaChevronDown
            className={`
              w-4 h-4 transition-transform duration-200
              ${isActive ? "rotate-180" : "rotate-0"}
              ${disabled ? "text-gray-400" : "text-gray-600"}
            `}
          />
        </div>
      </button>

      {/* Dropdown */}
      <div
        className={`
          absolute w-full mt-1 z-40 bg-white rounded-lg overflow-hidden
          transition-all duration-200 origin-top
          ${isActive ? "opacity-100 scale-100" : "opacity-0 scale-95 pointer-events-none"}
        `}
        style={{ 
          boxShadow: "0 10px 40px -10px rgba(0,0,0,0.15)" 
        }}
      >
        {/* Search input */}
        {searchable && (
          <div className="p-2 border-b relative">
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder={searchPlaceholder}
              className="w-full pl-8 pr-3 py-1.5 rounded-md border
                focus:outline-none focus:border-blue-500"
            />
            <FaSearch 
              className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" 
            />
          </div>
        )}

        {/* Options list */}
        <div 
          className="overflow-y-auto"
          style={{ maxHeight }}
        >
          {loading ? (
            <div className="py-3 px-4 text-center text-gray-500">
              Loading...
            </div>
          ) : filteredOptions.length > 0 ? (
            filteredOptions.map((option, index) => (
              <div className="cursor-pointer"
                key={typeof option === "object" ? option[valueKey] : option}
                onClick={() => handleSelect(option)}
              >
                {renderOptionItem(option)}
              </div>
            ))
          ) : (
            <div className="py-3 px-4 text-center text-gray-500">
              {noOptionsMessage}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default MultipleSelect;


// usage advanced example
// Advanced usage with object options

/*
const AdvancedExample = () => {
    const [value, setValue] = useState("");
    
    const options = [
      { id: 1, label: "Football", value: "football"},
      { id: 2, label: "Basketball", value: "basketball"},
      { id: 3, label: "Tennis", value: "tennis"}
    ];
    
    // Custom option renderer
    const renderOption = (option) => (
      <div className="flex items-center gap-2 py-2 px-4 hover:bg-gray-50">
        <span>{option.icon}</span>
        <span>{option.label}</span>
      </div>
    );
    
    return (
      <SelectWidget
        options={options}
        value={value}
        onChange={setValue}
        displayKey="label"
        valueKey="value"
        renderOption={renderOption}
        placeholder="Select a sport"
        width="w-64"
        searchable={true}
        clearable={true}
      />
    );
  };
  */
