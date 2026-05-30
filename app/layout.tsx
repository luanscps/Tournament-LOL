import type { Metadata } from "next";
import "./globals.css";
import { Navbar } from "@/components/layout/Navbar";

export const metadata: Metadata = {
  title: {
    default: "ArenaGG — Torneios de League of Legends BR",
    template: "%s — ArenaGG",
  },
  description: "Cadastre seu invocador, monte seu time e dispute torneios 5v5 de League of Legends com bracket, stats reais e ranking oficial Riot.",
  keywords: ["league of legends", "torneio", "lol", "brasil", "ranked", "5v5"],
  openGraph: {
    type: "website",
    locale: "pt_BR",
    siteName: "ArenaGG",
    title: "ArenaGG — Torneios de League of Legends BR",
    description: "Cadastre seu invocador, monte seu time e dispute torneios 5v5 com bracket, stats reais e ranking oficial Riot.",
  },
  twitter: {
    card: "summary_large_image",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="" />
        <link
          href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700;800&family=Inter:wght@300;400;500;600&display=swap"
          rel="stylesheet"
        />
      </head>
      <body className="min-h-screen">
        <Navbar />
        <main className="max-w-7xl mx-auto px-4 py-6">{children}</main>
      </body>
    </html>
  );
}
