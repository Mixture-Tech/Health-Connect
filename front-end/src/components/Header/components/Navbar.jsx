<<<<<<< HEAD
import React, { useState, useEffect } from "react";
import { IoIosSearch } from "react-icons/io";
import { CiMenuFries } from "react-icons/ci";
import { FiUser } from "react-icons/fi";
import { IoSettingsOutline } from "react-icons/io5";
import { TbLogout2} from "react-icons/tb";
import { pages } from '../../../mocks/header.data';
import Button from "../../Form/Button";
import Logo from "../../../assets/images/logo.png";
import { useNavigate } from "react-router-dom";
import Cookies from "js-cookie";
import { StorageKeys } from "../../../services/key/keys"; // Điều chỉnh đúng đường dẫn

export default function Navbar() {
    const [accountMenuOpen, setAccountMenuOpen] = useState(false);
    const [mobileSidebarOpen, setMobileSidebarOpen] = useState(false);
    const [isLoggedIn, setIsLoggedIn] = useState(false); // Kiểm tra trạng thái đăng nhập
    const navigate = useNavigate();

    // Lấy thông tin từ cookie và localStorage khi component được mount
    useEffect(() => {
        const token = Cookies.get(StorageKeys.ACCESS_TOKEN);
        const username = localStorage.getItem(StorageKeys.USER_NAME);
        const role = localStorage.getItem(StorageKeys.USER_ROLE);

        if (token && username && role) {
            setIsLoggedIn(true); // Nếu có token và thông tin người dùng, coi như đã đăng nhập
        }
    }, []);

    const handleLoginClick = () => {
        navigate("/dang-nhap"); // Chuyển hướng đến trang đăng nhập
    };

    const handleRegisterClick = () => {
        navigate("/dang-ky");
    };

    const handleLogout = () => {
        setIsLoggedIn(false); // Đăng xuất
        Cookies.remove(StorageKeys.ACCESS_TOKEN); // Xóa token khỏi cookie
        localStorage.removeItem(StorageKeys.USER_NAME); // Xóa thông tin người dùng
        localStorage.removeItem(StorageKeys.USER_ROLE); // Xóa vai trò người dùng
        navigate("/"); // Điều hướng về trang chủ sau khi đăng xuất
    };

    return (
        <nav className="flex bg-primary-100 items-center justify-between w-full relative px-4">
            {/* Logo */}
            <div className="flex-1 flex justify-start">
                <img src={Logo} alt="logo" className="w-[80px]" />
            </div>

            {/* Menu */}
            <ul className="flex-1 flex items-center justify-center gap-[20px] text-[1rem] text-[#424242] lg:flex hidden">
                {pages.map((page) => (
                    <li
                        key={page.key}
                        className={`hover:border-primary-1000 border-b-[2px] border-transparent transition-all duration-500 cursor-pointer hover:text-primary-900 capitalize ${
                            page.current ? "text-primary-900" : ""
                        }`}
                    >
                        <a href={page.href}>{page.name}</a>
                    </li>
                ))}
            </ul>

            {/* Search and Account */}
            <div className="flex-1 flex items-center justify-end gap-[10px]">
                <div className="relative lg:flex hidden">
                    <input
                        className="py-1.5 pr-4 border border-text pl-10 rounded-full outline-none focus:border-[#3B9DF8]"
                        placeholder="Search..."
                    />
                    <IoIosSearch className="absolute top-[9px] left-3 text-[#424242] text-[1.3rem]" />
                </div>

                {/* Nếu đã đăng nhập */}
                {isLoggedIn ? (
                    <div className="flex items-center gap-[10px] relative">
                        <div className="relative">
                            <img
                                src="https://genshin-guide.com/wp-content/uploads/raiden-shogun.webp"
                                alt="avatar"
                                className="w-[35px] h-[35px] rounded-full object-cover cursor-pointer"
                            />
                            <div className="w-[10px] h-[10px] rounded-full bg-green-500 absolute bottom-[0px] right-0 border-2 border-white"></div>
                        </div>
                        <CiMenuFries
                            onClick={() => setAccountMenuOpen(!accountMenuOpen)}
                            className="text-[1.8rem] text-[#424242] cursor-pointer"
                        />
                        <div
                            className={`${
                                accountMenuOpen ? "translate-y-0 opacity-100 z-[9999]" : "translate-y-[10px] opacity-0 z-[-1]"
                            } bg-white w-max rounded-md boxShadow absolute top-[45px] right-0 p-[10px] flex flex-col transition-all duration-300 gap-[5px]`}
                        >
                            <p className="flex items-center gap-[5px] rounded-md p-[8px] pr-[45px] py-[3px] text-[1rem] text-gray-600 hover:bg-gray-50 cursor-pointer">
                                <FiUser />
                                Thông tin cá nhân
                            </p>
                            {/*<p className="flex items-center gap-[5px] rounded-md p-[8px] pr-[45px] py-[3px] text-[1rem] text-gray-600 hover:bg-gray-50">
                                <IoSettingsOutline />
                                Settings
                            </p>*/}
                            <div className="mt-3 border-t border-gray-200 pt-[5px]">
                                <p
                                    onClick={handleLogout}
                                    className="flex items-center gap-[5px] rounded-md p-[8px] pr-[45px] py-[3px] text-[1rem] text-red-500 hover:bg-red-50 cursor-pointer"
                                >
                                    <TbLogout2 />
                                    Đăng xuất
                                </p>
                            </div>
                        </div>
                    </div>
                ) : (
                    // Nếu chưa đăng nhập, hiển thị nút đăng nhập và đăng ký
                    <div className="flex items-center gap-[5px] relative">
                        <Button className="login-button px-[10px]" onClick={handleLoginClick}>
                            Đăng nhập
                        </Button>
                        <Button className="register-button px-[10px]" onClick={handleRegisterClick}>
                            Đăng ký
                        </Button>
                    </div>
                )}
            </div>
        </nav>
    );
=======
import React, { useState } from 'react';
import Box from '@mui/material/Box';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import Button from '@mui/material/Button';
import Container from '@mui/material/Container';
import Divider from '@mui/material/Divider';
import Typography from '@mui/material/Typography';
import MenuItem from '@mui/material/MenuItem';
import Drawer from '@mui/material/Drawer';
import MenuIcon from '@mui/icons-material/Menu';
import { pages } from '../../../mocks/header.data';

const logoStyle = {
  width: '140px',
  height: 'auto',
  cursor: 'pointer',
};

export default function Navbar() {
  const [open, setOpen] = useState(false);

  const toggleDrawer = (newOpen) => () => {
    setOpen(newOpen);
  };

  const scrollToSection = (sectionId) => {
    const sectionElement = document.getElementById(sectionId);
    const offset = 128;
    if (sectionElement) {
      const targetScroll = sectionElement.offsetTop - offset;
      sectionElement.scrollIntoView({ behavior: 'smooth' });
      window.scrollTo({
        top: targetScroll,
        behavior: 'smooth',
      });
      setOpen(false);
    }
  };

  return (
    <div as="nav">
      <AppBar
        position="fixed"
        sx={{
          boxShadow: 0,
          bgcolor: 'transparent',
          backgroundImage: 'none',
          mt: 2,
        }}
      >
        <Container maxWidth="lg">
          <Toolbar
            variant="regular"
            sx={(theme) => ({
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              flexShrink: 0,
              borderRadius: '999px',
              bgcolor: 'rgba(255, 255, 255, 0.4)',
              backdropFilter: 'blur(24px)',
              maxHeight: 40,
              border: '1px solid',
              borderColor: 'divider',
              boxShadow: `0 0 1px rgba(85, 166, 246, 0.1), 1px 1.5px 2px -1px rgba(85, 166, 246, 0.15), 4px 4px 12px -2.5px rgba(85, 166, 246, 0.15)`,
            })}
          >
            <Box
              sx={{
                flexGrow: 1,
                display: 'flex',
                alignItems: 'center',
                ml: '-18px',
                px: 0,
              }}
            >
              <img
                src="https://assets-global.website-files.com/61ed56ae9da9fd7e0ef0a967/61f12e6faf73568658154dae_SitemarkDefault.svg"
                style={logoStyle}
                alt="logo of sitemark"
              />
              <Box sx={{ display: { xs: 'none', md: 'flex' } }}>
                {pages.map((page) => (
                  <MenuItem
                    key={page.key}
                    onClick={() => scrollToSection(page.name.toLowerCase())}
                    sx={{ py: '6px', px: '12px' }}
                  >
                    <Typography variant="body2" color="text.primary">
                      {page.name}
                    </Typography>
                  </MenuItem>
                ))}
              </Box>
            </Box>
            <Box
              sx={{
                display: { xs: 'none', md: 'flex' },
                gap: 0.5,
                alignItems: 'center',
              }}
            >
              <Button
                color="primary"
                variant="text"
                size="small"
                component="a"
                href="#"
                target="_blank"
              >
                Sign in
              </Button>
              <Button
                color="primary"
                variant="contained"
                size="small"
                component="a"
                href="#"
                target="_blank"
                className="!bg-blue-500"
              >
                Sign up
              </Button>
            </Box>
            <Box sx={{ display: { sm: '', md: 'none' } }}>
              <Button
                variant="text"
                color="primary"
                aria-label="menu"
                onClick={toggleDrawer(true)}
                sx={{ minWidth: '30px', p: '4px' }}
              >
                <MenuIcon />
              </Button>
              <Drawer anchor="right" open={open} onClose={toggleDrawer(false)}>
                <Box
                  sx={{
                    minWidth: '60dvw',
                    p: 2,
                    backgroundColor: 'background.paper',
                    flexGrow: 1,
                  }}
                >
                  {pages.map((page) => (
                    <MenuItem
                      key={page.key}
                      onClick={() => scrollToSection(page.name.toLowerCase())}>
                      {page.name}
                    </MenuItem>
                  ))}
                  <Divider />
                  <MenuItem>
                    <Button
                      color="primary"
                      variant="contained"
                      component="a"
                      href="#"
                      target="_blank"
                      sx={{ width: '100%' }}
                    >
                      Sign up
                    </Button>
                  </MenuItem>
                  <MenuItem>
                    <Button
                      color="primary"
                      variant="outlined"
                      component="a"
                      href="#"
                      target="_blank"
                      sx={{ width: '100%' }}
                    >
                      Sign in
                    </Button>
                  </MenuItem>
                </Box>
              </Drawer>
            </Box>
          </Toolbar>
        </Container>
      </AppBar>
    </div>
  );
>>>>>>> cd7818233d6b3267e48300f010af947bab4a426d
}
