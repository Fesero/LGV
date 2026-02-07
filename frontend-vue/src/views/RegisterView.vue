<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const form = ref({
  name: '',
  email: '',
  nickname: '',
  password: '',
  password_confirmation: '',
  spirit_root: '',
  sect: '',
  terms: false,
})

const validationErrors = ref<Record<string, string[]>>({})
const isSubmitting = ref(false)

// Form validity check
const isFormValid = computed(() => {
  return (
    form.value.name.length >= 3 &&
    form.value.email &&
    form.value.nickname &&
    form.value.password.length >= 8 &&
    form.value.password_confirmation &&
    form.value.spirit_root &&
    form.value.sect &&
    form.value.terms
  )
})

// Select sect
function selectSect(sectValue: string) {
  form.value.sect = sectValue
}

async function handleRegister() {
  // Check password match
  if (form.value.password !== form.value.password_confirmation) {
    validationErrors.value = {
      password: ['Мантры не совпадают! Проверьте пароли.']
    }
    return
  }

  isSubmitting.value = true
  
  const { success, errors } = await authStore.register({
    name: form.value.name,
    email: form.value.email,
    nickname: form.value.nickname,
    password: form.value.password,
    password_confirmation: form.value.password_confirmation,
  })

  if (success) {
    // TODO: Сохранить spirit_root и sect когда добавим в backend
    // localStorage.setItem('cultivator_root', form.value.spirit_root)
    // localStorage.setItem('cultivator_sect', form.value.sect)

    // Fade out animation
    document.body.style.opacity = '0'
    document.body.style.transition = 'opacity 0.5s ease'
    
    setTimeout(() => {
      router.push('/')
    }, 500)
  } else {
    validationErrors.value = errors || {}
    isSubmitting.value = false
  }
}
</script>

<template>
  <!-- Background -->
  <div class="bg-container">
    <img 
      src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2070" 
      alt="Mountain Peak" 
      class="bg-image"
    >
    <div class="bg-overlay"></div>
  </div>

  <!-- Navigation -->
  <nav class="navbar">
    <router-link to="/login" class="logo">
      <span class="logo-icon">☯</span>
      <span>修道之路</span>
    </router-link>
    <router-link to="/login" class="nav-link">Уже есть аккаунт? Войти</router-link>
  </nav>

  <!-- Main Content -->
  <div class="main-container">
    <div class="register-card">
      <div class="register-header">
        <div class="seal-icon">☯</div>
        <h1 class="register-title">开始修道之路</h1>
        <p class="register-subtitle">Создайте своего культиватора и начните путь к бессмертию</p>
      </div>

      <form @submit.prevent="handleRegister">
        <div class="form-sections">
          <!-- Left Section -->
          <div class="form-section">
            <h3>⚡ Основная информация</h3>

            <div class="form-group">
              <label class="form-label">Имя Культиватора</label>
              <input 
                v-model="form.name"
                type="text" 
                class="form-input" 
                placeholder="Выберите уникальное имя"
                required
                minlength="3"
                maxlength="20"
                :disabled="isSubmitting"
              >
              <span v-if="validationErrors.name" class="error-text">
                {{ validationErrors.name[0] }}
              </span>
            </div>

            <div class="form-group">
              <label class="form-label">Даосское Имя (Никнейм)</label>
              <input 
                v-model="form.nickname"
                type="text" 
                class="form-input" 
                placeholder="Ваш никнейм в мире культивации"
                required
                minlength="3"
                maxlength="20"
                :disabled="isSubmitting"
              >
              <span v-if="validationErrors.nickname" class="error-text">
                {{ validationErrors.nickname[0] }}
              </span>
            </div>

            <div class="form-group">
              <label class="form-label">Email</label>
              <input 
                v-model="form.email"
                type="email" 
                class="form-input" 
                placeholder="your@email.com"
                required
                :disabled="isSubmitting"
              >
              <span v-if="validationErrors.email" class="error-text">
                {{ validationErrors.email[0] }}
              </span>
            </div>

            <div class="form-group">
              <label class="form-label">Мантра Силы (Пароль)</label>
              <input 
                v-model="form.password"
                type="password" 
                class="form-input" 
                placeholder="Минимум 8 символов"
                required
                minlength="8"
                :disabled="isSubmitting"
              >
              <span v-if="validationErrors.password" class="error-text">
                {{ validationErrors.password[0] }}
              </span>
            </div>

            <div class="form-group">
              <label class="form-label">Подтвердите Мантру</label>
              <input 
                v-model="form.password_confirmation"
                type="password" 
                class="form-input" 
                placeholder="Повторите пароль"
                required
                :disabled="isSubmitting"
              >
            </div>
          </div>

          <!-- Right Section -->
          <div class="form-section">
            <h3>🏔️ Выбор характеристик</h3>

            <div class="form-group">
              <label class="form-label">Духовный Корень</label>
              <select 
                v-model="form.spirit_root" 
                class="form-select" 
                required
                :disabled="isSubmitting"
              >
                <option value="">Выберите корень</option>
                <option value="fire">🔥 Огненный - Сила атаки</option>
                <option value="water">💧 Водный - Контроль и лечение</option>
                <option value="earth">🗻 Земной - Защита</option>
                <option value="metal">⚔️ Металлический - Физический урон</option>
                <option value="wood">🌳 Древесный - Регенерация</option>
              </select>
            </div>

            <div class="form-group">
              <label class="form-label">Начальная Секта</label>
              <div class="sect-selection">
                <div 
                  class="sect-card"
                  :class="{ selected: form.sect === 'celestial' }"
                  @click="selectSect('celestial')"
                >
                  <div class="sect-icon">⚡</div>
                  <div class="sect-name">Небесная</div>
                  <div class="sect-desc">Баланс</div>
                </div>

                <div 
                  class="sect-card"
                  :class="{ selected: form.sect === 'demon' }"
                  @click="selectSect('demon')"
                >
                  <div class="sect-icon">😈</div>
                  <div class="sect-name">Демоническая</div>
                  <div class="sect-desc">Сила</div>
                </div>

                <div 
                  class="sect-card"
                  :class="{ selected: form.sect === 'sword' }"
                  @click="selectSect('sword')"
                >
                  <div class="sect-icon">⚔️</div>
                  <div class="sect-name">Меча</div>
                  <div class="sect-desc">Скорость</div>
                </div>

                <div 
                  class="sect-card"
                  :class="{ selected: form.sect === 'medical' }"
                  @click="selectSect('medical')"
                >
                  <div class="sect-icon">🌿</div>
                  <div class="sect-name">Медицинская</div>
                  <div class="sect-desc">Поддержка</div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="terms-checkbox">
          <input v-model="form.terms" type="checkbox" id="terms" required>
          <label for="terms">
            Я принимаю <a href="#">условия использования</a> и понимаю, 
            что путь культивации полон опасностей. Смерть персонажа может привести 
            к потере прогресса. Я готов принять все риски на своем пути к бессмертию.
          </label>
        </div>

        <button 
          type="submit" 
          class="submit-btn" 
          :disabled="!isFormValid || isSubmitting"
        >
          {{ isSubmitting ? 'Создание культиватора...' : 'Начать Культивацию' }}
        </button>
      </form>

      <div class="login-link">
        Уже культиватор? <router-link to="/login">Войти в мир</router-link>
      </div>
    </div>
  </div>
</template>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

:root {
  --bg-primary: #0a0a0a;
  --text-primary: #ffffff;
  --text-secondary: #a0a0a0;
  --accent-gold: #d4af37;
  --accent-red: #dc2626;
  --accent-jade: #10b981;
  --glass-bg: rgba(255, 255, 255, 0.05);
  --glass-border: rgba(255, 255, 255, 0.1);
}

/* Background */
.bg-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
}

.bg-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  filter: grayscale(30%) brightness(0.3);
  animation: zoomIn 25s ease-in-out infinite alternate;
}

@keyframes zoomIn {
  0% { transform: scale(1); }
  100% { transform: scale(1.08); }
}

.bg-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(10, 10, 10, 0.88) 0%, rgba(16, 10, 20, 0.85) 100%);
}

/* Navigation */
.navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  padding: 2rem 4rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  z-index: 100;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.9) 0%, transparent 100%);
}

.logo {
  font-size: 1.5rem;
  font-weight: 900;
  letter-spacing: 0.05em;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-family: 'Noto Serif SC', serif;
  text-decoration: none;
  color: var(--text-primary);
}

.logo-icon {
  font-size: 2rem;
  color: var(--accent-gold);
  filter: drop-shadow(0 0 10px var(--accent-gold));
}

.nav-link {
  color: var(--text-secondary);
  text-decoration: none;
  font-size: 0.9rem;
  font-weight: 500;
  transition: all 0.3s ease;
}

.nav-link:hover {
  color: var(--accent-gold);
}

/* Main Container */
.main-container {
  position: relative;
  z-index: 10;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 8rem 2rem 4rem;
}

.register-card {
  width: 100%;
  max-width: 1000px;
  background: var(--glass-bg);
  backdrop-filter: blur(40px);
  border: 1px solid var(--glass-border);
  border-radius: 24px;
  padding: 4rem;
  box-shadow: 0 30px 80px rgba(0, 0, 0, 0.6);
  position: relative;
}

.register-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--accent-red), var(--accent-gold), var(--accent-jade));
  border-radius: 24px 24px 0 0;
}

.register-header {
  text-align: center;
  margin-bottom: 3rem;
}

.seal-icon {
  font-size: 4rem;
  margin-bottom: 1rem;
  filter: drop-shadow(0 0 20px var(--accent-gold));
}

.register-title {
  font-family: 'Noto Serif SC', serif;
  font-size: 2.5rem;
  font-weight: 900;
  margin-bottom: 0.5rem;
  color: var(--accent-gold);
  text-shadow: 0 0 30px rgba(212, 175, 55, 0.3);
}

.register-subtitle {
  font-size: 1.1rem;
  color: var(--text-secondary);
}

.form-sections {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
}

.form-section h3 {
  font-size: 1.2rem;
  margin-bottom: 1.5rem;
  color: var(--accent-gold);
  font-weight: 700;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-label {
  display: block;
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 0.75rem;
  letter-spacing: 0.02em;
}

.form-input, .form-select {
  width: 100%;
  padding: 1rem 1.25rem;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 12px;
  font-family: 'Inter', sans-serif;
  font-size: 0.95rem;
  color: var(--text-primary);
  transition: all 0.3s ease;
  outline: none;
}

.form-input::placeholder {
  color: var(--text-secondary);
}

.form-input:focus, .form-select:focus {
  background: rgba(255, 255, 255, 0.12);
  border-color: var(--accent-gold);
  transform: translateY(-2px);
  box-shadow: 0 0 20px rgba(212, 175, 55, 0.2);
}

.form-input:disabled, .form-select:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.form-select {
  cursor: pointer;
}

.form-select option {
  background: var(--bg-primary);
  color: var(--text-primary);
}

.error-text {
  display: block;
  color: #ff6b6b;
  font-size: 0.85rem;
  margin-top: 0.5rem;
}

.sect-selection {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.sect-card {
  padding: 1.25rem;
  background: rgba(255, 255, 255, 0.05);
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  text-align: center;
}

.sect-card:hover {
  border-color: var(--accent-gold);
  background: rgba(212, 175, 55, 0.1);
  transform: translateY(-2px);
}

.sect-card.selected {
  border-color: var(--accent-gold);
  background: rgba(212, 175, 55, 0.15);
  box-shadow: 0 0 20px rgba(212, 175, 55, 0.3);
}

.sect-icon {
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.sect-name {
  font-weight: 600;
  margin-bottom: 0.25rem;
}

.sect-desc {
  font-size: 0.85rem;
  color: var(--text-secondary);
}

.terms-checkbox {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  margin: 2rem 0;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.03);
  border-radius: 12px;
}

.terms-checkbox input {
  width: 20px;
  height: 20px;
  cursor: pointer;
  accent-color: var(--accent-gold);
  margin-top: 2px;
}

.terms-checkbox label {
  font-size: 0.9rem;
  color: var(--text-secondary);
  line-height: 1.6;
  cursor: pointer;
}

.terms-checkbox a {
  color: var(--accent-gold);
  text-decoration: none;
}

.submit-btn {
  width: 100%;
  padding: 1.25rem;
  background: linear-gradient(135deg, var(--accent-gold) 0%, #b8941f 100%);
  color: var(--bg-primary);
  border: none;
  border-radius: 12px;
  font-family: 'Inter', sans-serif;
  font-size: 1rem;
  font-weight: 700;
  letter-spacing: 0.05em;
  cursor: pointer;
  transition: all 0.3s ease;
  text-transform: uppercase;
  box-shadow: 0 10px 30px rgba(212, 175, 55, 0.3);
}

.submit-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 15px 40px rgba(212, 175, 55, 0.5);
}

.submit-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.login-link {
  text-align: center;
  margin-top: 2rem;
  font-size: 0.95rem;
  color: var(--text-secondary);
}

.login-link a {
  color: var(--accent-gold);
  text-decoration: none;
  font-weight: 600;
}

@media (max-width: 968px) {
  .form-sections {
    grid-template-columns: 1fr;
    gap: 2rem;
  }

  .sect-selection {
    grid-template-columns: 1fr;
  }

  .register-card {
    padding: 2.5rem 2rem;
  }

  .register-title {
    font-size: 2rem;
  }
}

@media (max-width: 640px) {
  .navbar {
    padding: 1.5rem;
  }

  .main-container {
    padding: 6rem 1.5rem 2rem;
  }

  .register-card {
    padding: 2rem 1.5rem;
  }

  .register-title {
    font-size: 1.75rem;
  }
}
</style>
