export interface ConnectWalletRequest {
  address: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  message: string;
}
