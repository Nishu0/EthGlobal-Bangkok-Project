import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";
import { formatEther } from "viem";
import {
  CheckCircledIcon,
  CircleIcon,
  CrossCircledIcon,
  QuestionMarkCircledIcon,
  StopwatchIcon,
} from "@radix-ui/react-icons";
import { format } from "date-fns";
export enum TransactionStatus {
  Unknow = "Unknown",
  InProgress = "In-Progress",
  Done = "Done",
  Canceled = "Canceled",
}
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export const truncate = (
  str: string | null | undefined = "",
  num: number
): string => {
  if (str == null) return "";
  const strValue = String(str);
  if (strValue.length <= num) {
    return strValue;
  }
  return strValue.slice(0, num) + "..." + strValue.slice(-num);
};

export const toDateString = (date: Date) => {
  return new Date(date).toLocaleDateString("en-US", {
    month: "short",
    day: "numeric",
    year: "numeric",
  });
};

export const safeValue = (value: number | null) => {
  const numValue = Number(value);
  return isNaN(numValue) ? "0" : formatNumber(numValue, 3);
};

export function formatNumber(input?: number, decimals?: number) {
  if (input === undefined || input === null) return 0;
  return input.toLocaleString("en-US", {
    maximumFractionDigits: decimals ?? 3,
    notation: "compact",
  });
}

export function BigIntToNumber(value?: bigint) {
  if (!value) {
    return 0;
  }
  return Number(formatEther(value));
}
export const capitalize = (s: string) => {
  if (typeof s !== "string") return "";
  return s.charAt(0).toUpperCase() + s.slice(1);
};

export function formatStatus(status?: string) {
  if (!status) return "";
  const wordArr = status?.split("_");
  wordArr.map((wrd) => {
    return capitalize(wrd?.toLowerCase());
  });
  return wordArr.join(" ");
}

export function getTransactionStatusIcon(status: TransactionStatus) {
  switch (status) {
    case TransactionStatus.Canceled:
      return CrossCircledIcon;
    case TransactionStatus.Done:
      return CheckCircledIcon;
    case TransactionStatus.InProgress:
      return StopwatchIcon;
    case TransactionStatus.Unknow:
      return QuestionMarkCircledIcon;
    default:
      return CircleIcon;
  }
}

export function formatDate(customTimestamp?: number) {
  if (!customTimestamp) return "";
  return format(new Date(customTimestamp * 1000), "MMM d, yyyy");
}

export function formatDateLong(date: Date) {
  const options: Intl.DateTimeFormatOptions = {
    day: "numeric",
    month: "long",
    year: "numeric",
  };

  const formatted = date.toLocaleDateString("en-US", options);
  const day = date.getDate();

  const suffix = ["th", "st", "nd", "rd"][
    day % 10 > 3 ? 0 : (day % 100) - (day % 10) !== 10 ? day % 10 : 0
  ];

  return formatted.replace(/(\d+)/, `$1${suffix}`);
}
