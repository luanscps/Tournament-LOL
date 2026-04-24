import React from "react";
import { notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { UserPermissionsForm } from "@/components/admin/UserPermissionsForm";

async function getUsuario(id: string) {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("profiles")
    .select("id, email, full_name, is_admin, is_banned, created_at")
    .eq("id", id)
    .single();
  if (error || !data) return null;
  return data;
}

export default async function AdminUsuarioDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const user = await getUsuario(slug);
  if (!user) return notFound();

  return (
    <div className="p-6 max-w-2xl">
      <div className="flex items-center gap-2 mb-6">
        <Link href="/admin/usuarios" className="text-gray-400 hover:text-white text-sm">
          ← Usuarios
        </Link>
        <span className="text-gray-600">/</span>
        <span className="text-white text-sm">{user.email}</span>
      </div>

      <h1 className="text-2xl font-bold text-white mb-1">
        {user.full_name || user.email}
      </h1>
      <p className="text-gray-500 text-xs mb-6">ID: {user.id}</p>

      <div className="bg-[#0A1628] border border-[#1E3A5F] rounded-xl p-5 mb-6">
        <div className="grid grid-cols-2 gap-4">
          <div>
            <p className="text-gray-500 text-xs mb-1">Email</p>
            <p className="text-white text-sm">{user.email}</p>
          </div>
          <div>
            <p className="text-gray-500 text-xs mb-1">Nome</p>
            <p className="text-white text-sm">{user.full_name || "—"}</p>
          </div>
          <div>
            <p className="text-gray-500 text-xs mb-1">Admin</p>
            <p className={`text-sm font-semibold ${user.is_admin ? "text-yellow-400" : "text-gray-500"}`}>
              {user.is_admin ? "Sim" : "Não"}
            </p>
          </div>
          <div>
            <p className="text-gray-500 text-xs mb-1">Banido</p>
            <p className={`text-sm font-semibold ${user.is_banned ? "text-red-400" : "text-green-400"}`}>
              {user.is_banned ? "Banido" : "Ativo"}
            </p>
          </div>
          <div className="col-span-2">
            <p className="text-gray-500 text-xs mb-1">Criado em</p>
            <p className="text-white text-sm">
              {new Date(user.created_at).toLocaleDateString("pt-BR", {
                day: "2-digit", month: "long", year: "numeric",
              })}
            </p>
          </div>
        </div>
      </div>

      {/* FIX: adicionado displayName que é required na interface Props */}
      <UserPermissionsForm
        userId={user.id}
        isAdmin={user.is_admin}
        isBanned={user.is_banned}
        displayName={user.full_name || user.email}
      />

      <div className="mt-6">
        <Link href="/admin/usuarios" className="text-gray-400 hover:text-white text-sm">
          ← Voltar para Usuarios
        </Link>
      </div>
    </div>
  );
}
