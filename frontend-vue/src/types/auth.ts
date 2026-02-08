export interface User {
    id: number
    name: string
    email: string
    character?: Character
  }
  
  export interface Character {
    nickname: string
    level: number
  }
  
  export interface LoginCredentials {
    email: string
    password: string
  }
  
  export interface RegisterData {
    name: string
    email: string
    nickname: string
    password: string
    password_confirmation: string
  }
  
  export interface AuthResponse {
    user: User
  }
  
  export interface ValidationError {
    message: string
    errors: Record<string, string[]>
  }
  