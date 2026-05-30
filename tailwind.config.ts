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
        gold: {
          DEFAULT: "#C8A84B",
          light:   "#E8D48B",
          dark:    "#8B6914",
        },
        lol: {
          blue:   "#0BC4E3",
          dark:   "#0A1428",
          darker: "#050D1A",
          card:   "#112240",
          border: "#1E3A5F",
        },
        /* ── Tremor custom theme (paleta ArenaGG) ────────────────── */
        tremor: {
          brand: {
            faint:    "#050D1A",
            muted:    "#112240",
            subtle:   "rgba(200,168,75,0.15)",
            DEFAULT:  "#C8A84B",
            emphasis: "#E8D48B",
            inverted: "#050D1A",
          },
          background: {
            muted:    "#0A1428",
            subtle:   "#112240",
            DEFAULT:  "#0D1B2E",
            emphasis: "#1E3A5F",
          },
          border: {
            DEFAULT: "rgba(30,58,95,0.9)",
          },
          ring: {
            DEFAULT: "#C8A84B",
          },
          content: {
            subtle:   "#4B5563",
            DEFAULT:  "#94A3B8",
            emphasis: "#F1F5F9",
            strong:   "#FFFFFF",
            inverted: "#050D1A",
          },
        },
      },
      fontFamily: {
        display: ["Sora", "Inter", "sans-serif"],
        body:    ["Inter", "sans-serif"],
      },
      animation: {
        shimmer: "shimmer 1.5s ease-in-out infinite",
        float:   "float 3s ease-in-out infinite",
      },
      keyframes: {
        shimmer: {
          "0%":   { backgroundPosition: "-200% 0" },
          "100%": { backgroundPosition:  "200% 0"  },
        },
        float: {
          "0%, 100%": { transform: "translateY(0px)" },
          "50%":      { transform: "translateY(-6px)" },
        },
      },
    },
  },
  plugins: [],
};

export default config;
