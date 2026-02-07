import apiClient from './client'
import type { AuthResponse, LoginCredentials, RegisterData, User } from '../types/auth'

export const authApi = {
  async login(credentials: LoginCredentials): Promise<User> {
    const { data } = await apiClient.post<AuthResponse>('/api/login', credentials)
    return data.user
  },

  async register(userData: RegisterData): Promise<User> {
    const { data } = await apiClient.post<AuthResponse>('/api/register', userData)
    return data.user
  },

  async getUser(): Promise<User> {
    const { data } = await apiClient.get<{ data: User }>('/api/me')
    return data.data
  },

  async logout(): Promise<void> {
    await apiClient.post('/api/logout')
  },
}
