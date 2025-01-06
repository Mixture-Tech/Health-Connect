/** @type {import('tailwindcss').Config} */
<<<<<<< HEAD
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
=======
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
        colors: {
            "blue": {
                50: "#e8eaf6",
                100: "#c5cae9",
                200: "#9fa8da",
                300: "#7986cb",
                400: "#5c6bc0",
                500: "#3f51b5",
                600: "#3949ab",
                700: "#303f9f",
                800: "#283593",
                900: "#1a237e",
            },
        },
    },
  },
  plugins: [],
}
>>>>>>> cd7818233d6b3267e48300f010af947bab4a426d
