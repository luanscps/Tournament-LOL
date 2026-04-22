import { createClient } from '@/lib/supabase/server'
import { notFound, redirect } from 'next/navigation'
import Link from 'next/link'

export const revalidate = 0

interface AuditLog {
  id: string
  created_at: string
  admin_id: string | null
  action: string
  table_name: string
  record_id: string | null
  old_data: Record<string, unknown> | null
  new_data: Record<string, unknown> | null
  users?: { email: string | null } | null
}

export default async function AuditLogPage({
  searchParams,
}: {
  searchParams: Promise<{ page?: string; table?: string; action?: string }>
}) {
  const { page: pageParam, table: tableFilter, action: actionFilter } = await searchParams
  const supabase = await createClient()

  // Check admin access
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  const { data: profile } = await supabase
    .from('users')
    .select('role')
    .eq('id', user.id)
    .single()

  if (profile?.role !== 'admin') notFound()

  const page = parseInt(pageParam ?? '1')
  const limit = 50
  const offset = (page - 1) * limit

  let query = supabase
    .from('audit_log')
    .select('*, users(email)', { count: 'exact' })
    .order('created_at', { ascending: false })
    .range(offset, offset + limit - 1)

  if (tableFilter) query = query.eq('table_name', tableFilter)
  if (actionFilter) query = query.eq('action', actionFilter)

  const { data: logs, count } = await query

  const totalPages = Math.ceil((count ?? 0) / limit)

  const actionColors: Record<string, string> = {
    INSERT: 'bg-green-900/30 text-green-400 border border-green-800',
    UPDATE: 'bg-yellow-900/30 text-yellow-400 border border-yellow-800',
    DELETE: 'bg-red-900/30 text-red-400 border border-red-800',
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-[#C89B3C]">Log de Auditoria</h1>
          <p className="text-gray-400 text-sm mt-1">
            Registro de todas as ações administrativas no sistema
          </p>
        </div>
        <div className="text-sm text-gray-500">
          Total: <span className="text-white font-semibold">{count ?? 0}</span> registros
        </div>
      </div>

      {/* Filters */}
      <div className="card-lol">
        <form className="flex flex-wrap gap-3" method="GET">
          <select
            name="table"
            defaultValue={tableFilter ?? ''}
            className="input-lol text-sm py-2 px-3 min-w-[150px]"
          >
            <option value="">Todas as tabelas</option>
            <option value="matches">matches</option>
            <option value="tournaments">tournaments</option>
            <option value="inscricoes">inscricoes</option>
            <option value="players">players</option>
            <option value="teams">teams</option>
          </select>

          <select
            name="action"
            defaultValue={actionFilter ?? ''}
            className="input-lol text-sm py-2 px-3 min-w-[130px]"
          >
            <option value="">Todas as ações</option>
            <option value="INSERT">INSERT</option>
            <option value="UPDATE">UPDATE</option>
            <option value="DELETE">DELETE</option>
          </select>

          <button type="submit" className="btn-primary px-4 py-2 text-sm">
            Filtrar
          </button>

          {(tableFilter || actionFilter) && (
            <Link href="/admin/audit" className="btn-secondary px-4 py-2 text-sm">
              Limpar
            </Link>
          )}
        </form>
      </div>

      {/* Table */}
      <div className="card-lol overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-[#785A28] bg-[#1E2328]">
                <th className="text-left px-4 py-3 text-[#C89B3C] font-semibold">Data/Hora</th>
                <th className="text-left px-4 py-3 text-[#C89B3C] font-semibold">Admin</th>
                <th className="text-left px-4 py-3 text-[#C89B3C] font-semibold">Ação</th>
                <th className="text-left px-4 py-3 text-[#C89B3C] font-semibold">Tabela</th>
                <th className="text-left px-4 py-3 text-[#C89B3C] font-semibold">Record ID</th>
                <th className="text-left px-4 py-3 text-[#C89B3C] font-semibold">Detalhes</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#3C3C41]">
              {(logs as AuditLog[] | null)?.map((log) => (
                <tr key={log.id} className="hover:bg-[#1E2328]/50 transition-colors">
                  <td className="px-4 py-3 text-gray-300 whitespace-nowrap">
                    {new Date(log.created_at).toLocaleString('pt-BR', {
                      timeZone: 'America/Sao_Paulo',
                      day: '2-digit',
                      month: '2-digit',
                      year: 'numeric',
                      hour: '2-digit',
                      minute: '2-digit',
                      second: '2-digit',
                    })}
                  </td>
                  <td className="px-4 py-3 text-gray-300">
                    {(log as { users?: { email?: string | null } | null }).users?.email ?? (
                      <span className="text-gray-600 italic">Sistema</span>
                    )}
                  </td>
                  <td className="px-4 py-3">
                    <span
                      className={`px-2 py-0.5 rounded text-xs font-mono font-bold ${
                        actionColors[log.action] ?? 'bg-gray-700 text-gray-300'
                      }`}
                    >
                      {log.action}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <span className="font-mono text-purple-400 text-xs bg-purple-900/20 px-2 py-0.5 rounded border border-purple-800">
                      {log.table_name}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    {log.record_id ? (
                      <span className="font-mono text-xs text-gray-400">
                        {log.record_id.slice(0, 8)}...
                      </span>
                    ) : (
                      <span className="text-gray-600">-</span>
                    )}
                  </td>
                  <td className="px-4 py-3">
                    <details className="group">
                      <summary className="cursor-pointer text-blue-400 hover:text-blue-300 text-xs">
                        Ver dados
                      </summary>
                      <div className="mt-2 space-y-2">
                        {log.old_data && (
                          <div>
                            <p className="text-xs text-red-400 font-semibold mb-1">Antes:</p>
                            <pre className="text-xs bg-[#0D1117] text-gray-300 p-2 rounded overflow-auto max-w-xs max-h-32 border border-red-900">
                              {JSON.stringify(log.old_data, null, 2)}
                            </pre>
                          </div>
                        )}
                        {log.new_data && (
                          <div>
                            <p className="text-xs text-green-400 font-semibold mb-1">Depois:</p>
                            <pre className="text-xs bg-[#0D1117] text-gray-300 p-2 rounded overflow-auto max-w-xs max-h-32 border border-green-900">
                              {JSON.stringify(log.new_data, null, 2)}
                            </pre>
                          </div>
                        )}
                      </div>
                    </details>
                  </td>
                </tr>
              ))}

              {(!logs || logs.length === 0) && (
                <tr>
                  <td colSpan={6} className="px-4 py-12 text-center text-gray-500">
                    Nenhum registro encontrado
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex items-center justify-center gap-2">
          {page > 1 && (
            <Link
              href={`/admin/audit?page=${page - 1}${tableFilter ? `&table=${tableFilter}` : ''}${
                actionFilter ? `&action=${actionFilter}` : ''
              }`}
              className="btn-secondary px-4 py-2 text-sm"
            >
              ← Anterior
            </Link>
          )}

          <span className="text-gray-400 text-sm">
            Página {page} de {totalPages}
          </span>

          {page < totalPages && (
            <Link
              href={`/admin/audit?page=${page + 1}${tableFilter ? `&table=${tableFilter}` : ''}${
                actionFilter ? `&action=${actionFilter}` : ''
              }`}
              className="btn-secondary px-4 py-2 text-sm"
            >
              Próxima →
            </Link>
          )}
        </div>
      )}
    </div>
  )
}
