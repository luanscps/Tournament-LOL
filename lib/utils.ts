import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";
export function cn(...inputs: ClassValue[]) { return twMerge(clsx(inputs)); }
export function formatRank(tier: string, rank: string, lp: number): string {
  if (["CHALLENGER","GRANDMASTER","MASTER"].includes(tier)) return tier + " " + lp + " LP";
  return tier + " " + rank + " — " + lp + " LP";
}
export function getTierColor(tier: string): string {
  const m: Record<string,string> = {
    IRON:"#8B7A6B",BRONZE:"#CD7F32",SILVER:"#A8A9AD",GOLD:"#FFD700",
    PLATINUM:"#00E5CC",EMERALD:"#50C878",DIAMOND:"#99CCFF",
    MASTER:"#9B59B6",GRANDMASTER:"#E74C3C",CHALLENGER:"#00D4FF",
  };
  return m[tier] ?? "#FFFFFF";
}
export function getWinRate(wins: number, losses: number): number {
  const t = wins + losses;
  return t === 0 ? 0 : Math.round((wins / t) * 100);
}
export function getQueueLabel(queue: string): string {
  const m: Record<string,string> = {
    RANKED_SOLO_5x5:"Ranqueada Solo/Duo", RANKED_FLEX_SR:"Ranqueada Flex",
    NORMAL_5x5_DRAFT:"Normal Draft", ARAM:"ARAM",
  };
  return m[queue] ?? queue;
}
export function formatDuration(seconds: number): string {
  return Math.floor(seconds/60) + "m " + String(seconds%60).padStart(2,"0") + "s";
}
export function calcKDA(k: number, d: number, a: number): string {
  return d === 0 ? "Perfect" : ((k+a)/d).toFixed(2);
}
