/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
      extend: {
          colors: {
              primary: {
                  DEFAULT: "#48CFCB",
                  50: "#D8F7F6",
                  100: "#BDF1F0",
                  200: "#9AE8E6",
                  300: "#77DFDC",
                  400: "#54D7D1",
                  500: "#48CFCB",
                  600: "#3FBAB5",
                  700: "#36A5A0",
                  800: "#2C908A",
                  900: "#237A75",
                  1000: "#1A6560",
              },
              secondary: {
                DEFAULT: "#424242",
                50: "#E0E0E0",
                100: "#BDBDBD",
                200: "#9E9E9E",
                300: "#757575",
                400: "#616161",
                500: "#424242",
                600: "#373737",
                700: "#2C2C2C",
                800: "#212121",
                900: "#1B1B1B",
                1000: "#141414",
              },
              // Add any additional colors here
          },
      },
  },
  plugins: [],
};
