import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/login',
      name: 'login',
      component: () => import('../views/LoginView.vue'),
      meta: { requiresGuest: true },
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('../views/RegisterView.vue'),
      meta: { requiresGuest: true },
    },
    {
      path: '/',
      name: 'dashboard',
      component: () => import('../views/DashboardView.vue'),
      meta: { requiresAuth: true },
    },
  ],
})

let authChecked = false

router.beforeEach(async (to, from, next) => {
  const authStore = useAuthStore()

  // Проверяем auth только один раз при первой загрузке
  if (!authChecked) {
    await authStore.fetchUser()
    authChecked = true
  }

  // Защищённые страницы
  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next('/login')
    return
  }
  
  // Гостевые страницы (login/register) - если уже залогинен, редирект на главную
  if (to.meta.requiresGuest && authStore.isAuthenticated) {
    next('/')
    return
  }
  
  // Всё ок, пропускаем
  next()
})

export default router
