import type { Config } from "tailwindcss";
const config: Config = {
  darkMode: ["class"],
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        gold: { DEFAULT: "#C8A84B", light: "#E8D48B", dark: "#8B6914" },
        lol:  { blue: "#0BC4E3", dark: "#0A1428", darker: "#050D1A", card: "#112240", border: "#1E3A5F" },
      },
    },
  },
  plugins: [],
};
export default config;
