import axios from 'axios'

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8085'

const apiClient = axios.create({
  baseURL: API_URL,
  withCredentials: true,
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
})

let csrfInitialized = false

apiClient.interceptors.request.use(async (config) => {
  const needsCsrf = ['post', 'put', 'patch', 'delete'].includes(config.method?.toLowerCase() || '')
  
  if (needsCsrf && !csrfInitialized) {
    try {
      await axios.get(`${API_URL}/sanctum/csrf-cookie`, {
        withCredentials: true,
      })
      csrfInitialized = true
      
      // Небольшая задержка чтобы cookie успела установиться
      await new Promise(resolve => setTimeout(resolve, 100))
    } catch (error) {
      console.error('CSRF cookie fetch failed:', error)
      throw error // Прерываем запрос если CSRF не получен
    }
  }
  
  return config
})

// Убираем response interceptor - он создавал бесконечный цикл
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    // Просто пробрасываем ошибку без повторов
    return Promise.reject(error)
  }
)

export default apiClient
