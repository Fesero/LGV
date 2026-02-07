import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { authApi } from '../api/auth'
import type { User, LoginCredentials, RegisterData } from '../types/auth'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const loading = ref(false)
  const error = ref<string | null>(null)

  const isAuthenticated = computed(() => user.value !== null)
  
  const cultivatorName = computed(() => 
    user.value?.character?.nickname || user.value?.name || 'Даосист'
  )

  async function login(credentials: LoginCredentials) {
    loading.value = true
    error.value = null
    try {
      user.value = await authApi.login(credentials)
      return true
    } catch (err: any) {
      error.value = err.response?.data?.message || 'Неверные учётные данные'
      return false
    } finally {
      loading.value = false
    }
  }

  async function register(data: RegisterData) {
    loading.value = true
    error.value = null
    try {
      user.value = await authApi.register(data)
      return { success: true, errors: null }
    } catch (err: any) {
      const errors = err.response?.data?.errors || {}
      error.value = err.response?.data?.message || 'Ошибка регистрации'
      return { success: false, errors }
    } finally {
      loading.value = false
    }
  }

  async function fetchUser() {
    try {
      user.value = await authApi.getUser()
    } catch (err: any) {
      // 401 - пользователь не залогинен (это нормально)
      // Не показываем ошибку, просто сбрасываем user
      user.value = null
    }
  }

  async function logout() {
    loading.value = true
    try {
      await authApi.logout()
      user.value = null
    } catch (err) {
      // Игнорируем ошибки logout
      user.value = null
    } finally {
      loading.value = false
    }
  }

  return {
    user,
    loading,
    error,
    isAuthenticated,
    cultivatorName,
    login,
    register,
    fetchUser,
    logout,
  }
})
