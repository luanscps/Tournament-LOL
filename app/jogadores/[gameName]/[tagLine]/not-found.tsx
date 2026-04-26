import Link from "next/link";

export default function NotFoundJogador() {
  return (
    <div className="min-h-screen bg-[#050E1A] flex items-center justify-center px-4">
      <div style={{ textAlign: "center", maxWidth: 400 }}>
        <p style={{ fontSize: 56, marginBottom: 16 }}>🔍</p>
        <h1 style={{ fontSize: 22, fontWeight: 800, color: "#fff", marginBottom: 8 }}>
          Jogador não encontrado
        </h1>
        <p style={{ fontSize: 14, color: "#6B7280", marginBottom: 24 }}>
          Verifique o nick e a tag e tente novamente.
        </p>
        <Link
          href="/jogadores"
          style={{
            background: "#C8A84B", color: "#050E1A",
            fontWeight: 700, borderRadius: 8, padding: "10px 24px",
            textDecoration: "none", fontSize: 14,
          }}
        >
          ← Voltar para Jogadores
        </Link>
      </div>
    </div>
  );
}
