<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const form = ref({
  email: '',
  password: '',
  remember: false,
})

const isSubmitting = ref(false)

// Create particles animation
function createParticles() {
  const container = document.getElementById('particles')
  if (!container) return
  
  const particleCount = 50

  for (let i = 0; i < particleCount; i++) {
    const particle = document.createElement('div')
    particle.className = 'particle'
    particle.style.left = Math.random() * 100 + '%'
    particle.style.setProperty('--drift', (Math.random() * 200 - 100) + 'px')
    particle.style.animationDelay = Math.random() * 10 + 's'
    particle.style.animationDuration = (8 + Math.random() * 6) + 's'
    container.appendChild(particle)
  }
}

async function handleLogin() {
  isSubmitting.value = true
  
  const success = await authStore.login({
    email: form.value.email,
    password: form.value.password,
  })
  
  if (success) {
    // Fade out animation before redirect
    document.body.style.opacity = '0'
    document.body.style.transition = 'opacity 0.5s ease'
    
    setTimeout(() => {
      router.push('/')
    }, 500)
  } else {
    isSubmitting.value = false
  }
}

onMounted(() => {
  createParticles()
})
</script>

<template>
  <!-- Background -->
  <div class="bg-container">
    <img 
      src="https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=2070" 
      alt="Mountains" 
      class="bg-image"
    >
    <div class="bg-overlay"></div>
  </div>

  <!-- Particles -->
  <div class="particles" id="particles"></div>

  <!-- Navigation -->
  <nav class="navbar">
    <div class="logo">
      <span class="logo-icon">☯</span>
      <span>修道之路</span>
    </div>
    <ul class="nav-links">
      <li><router-link to="/login" class="active">Вход</router-link></li>
      <li><router-link to="/register">Регистрация</router-link></li>
      <li><a href="#">О игре</a></li>
      <li><a href="#">Форум</a></li>
    </ul>
  </nav>

  <!-- Main Content -->
  <div class="main-container">
    <!-- Left Side - Content -->
    <div class="content-side">
      <div class="category">
        <span>Путь Культивации</span>
      </div>

      <h1 class="chinese-title">修道之路</h1>

      <h2 class="main-title">
        Cultivation<br>Path
      </h2>

      <p class="subtitle">
        Начните свой путь к бессмертию в мире восточной фантазии. 
        Культивируйте энергию Ци, постигайте древние техники и станьте легендой.
      </p>

      <div class="features">
        <div class="feature-item">
          <div class="feature-title">⚡ Культивация</div>
          <div class="feature-desc">Развивайте свою энергию Ци и повышайте уровень</div>
        </div>
        <div class="feature-item">
          <div class="feature-title">⚔️ Сражения</div>
          <div class="feature-desc">Участвуйте в турнирах и PvP боях</div>
        </div>
        <div class="feature-item">
          <div class="feature-title">📜 Техники</div>
          <div class="feature-desc">Изучайте мощные боевые искусства</div>
        </div>
        <div class="feature-item">
          <div class="feature-title">🏔️ Секты</div>
          <div class="feature-desc">Присоединяйтесь к могущественным кланам</div>
        </div>
      </div>
    </div>

    <!-- Right Side - Login Form -->
    <div class="login-side">
      <div class="login-card">
        <div class="login-header">
          <div class="seal-icon">☯</div>
          <h2 class="login-title">Вход в мир</h2>
          <p class="login-subtitle">Войдите, чтобы продолжить культивацию</p>
        </div>

        <form @submit.prevent="handleLogin">
          <div class="form-group">
            <label class="form-label">Email Культиватора</label>
            <input 
              v-model="form.email"
              type="email" 
              class="form-input" 
              placeholder="Введите ваш email"
              required
              :disabled="isSubmitting"
            >
          </div>

          <div class="form-group">
            <label class="form-label">Мантра Силы</label>
            <input 
              v-model="form.password"
              type="password" 
              class="form-input" 
              placeholder="Введите вашу мантру"
              required
              :disabled="isSubmitting"
            >
          </div>

          <!-- Error message -->
          <div v-if="authStore.error" class="error-message">
            {{ authStore.error }}
          </div>

          <div class="form-options">
            <div class="checkbox-wrapper">
              <input v-model="form.remember" type="checkbox" id="remember">
              <label for="remember">Запомнить меня</label>
            </div>
            <a href="#" class="forgot-link">Забыли мантру?</a>
          </div>

          <button type="submit" class="submit-btn" :disabled="isSubmitting">
            {{ isSubmitting ? 'Вход...' : 'Войти в Мир' }}
          </button>
        </form>

        <div class="divider">
          <span>或</span>
        </div>

        <div class="register-link">
          Новый культиватор? <router-link to="/register">Начните свой путь</router-link>
        </div>
      </div>
    </div>
  </div>

  <!-- Page Indicator -->
  <div class="page-indicator">
    <div class="indicator-dot active"></div>
    <div class="indicator-dot"></div>
    <div class="indicator-dot"></div>
    <div class="indicator-dot"></div>
    <div class="indicator-dot"></div>
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
  --bg-secondary: #1a1a1a;
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
  filter: grayscale(20%) brightness(0.35);
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
  background: linear-gradient(135deg, rgba(10, 10, 10, 0.85) 0%, rgba(20, 10, 10, 0.75) 50%, rgba(10, 10, 20, 0.85) 100%);
}

/* Particles */
.particles {
  position: fixed;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  z-index: 1;
  pointer-events: none;
  overflow: hidden;
}

:deep(.particle) {
  position: absolute;
  width: 3px;
  height: 3px;
  background: var(--accent-gold);
  border-radius: 50%;
  opacity: 0;
  animation: particleFloat 10s infinite ease-in-out;
  box-shadow: 0 0 10px var(--accent-gold);
}

@keyframes particleFloat {
  0% {
    transform: translateY(100vh) translateX(0) rotate(0deg);
    opacity: 0;
  }
  10% {
    opacity: 0.8;
  }
  90% {
    opacity: 0.6;
  }
  100% {
    transform: translateY(-100px) translateX(var(--drift)) rotate(360deg);
    opacity: 0;
  }
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
}

.logo-icon {
  font-size: 2rem;
  color: var(--accent-gold);
  filter: drop-shadow(0 0 10px var(--accent-gold));
}

.nav-links {
  display: flex;
  gap: 2.5rem;
  list-style: none;
}

.nav-links a {
  color: var(--text-secondary);
  text-decoration: none;
  font-size: 0.9rem;
  font-weight: 500;
  transition: all 0.3s ease;
  position: relative;
}

.nav-links a:hover {
  color: var(--accent-gold);
}

.nav-links a.active {
  color: var(--text-primary);
}

/* Main Content */
.main-container {
  position: relative;
  z-index: 10;
  min-height: 100vh;
  display: grid;
  grid-template-columns: 1fr 1fr;
  padding: 0 4rem;
  padding-top: 6rem;
}

/* Left Side - Content */
.content-side {
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding-right: 4rem;
  padding-bottom: 4rem;
}

.category {
  font-size: 0.75rem;
  font-weight: 600;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: var(--accent-gold);
  margin-bottom: 1.5rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.category::before {
  content: '';
  width: 30px;
  height: 2px;
  background: var(--accent-gold);
  box-shadow: 0 0 10px var(--accent-gold);
}

.chinese-title {
  font-family: 'Noto Serif SC', serif;
  font-size: 3rem;
  font-weight: 900;
  color: var(--accent-gold);
  margin-bottom: 1rem;
  text-shadow: 0 0 30px rgba(212, 175, 55, 0.5);
  letter-spacing: 0.1em;
}

.main-title {
  font-size: 6.5rem;
  font-weight: 900;
  line-height: 0.9;
  letter-spacing: -0.04em;
  margin-bottom: 1.5rem;
  text-transform: uppercase;
  background: linear-gradient(135deg, #ffffff 0%, var(--accent-gold) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.subtitle {
  font-size: 1.1rem;
  font-weight: 300;
  color: var(--text-secondary);
  margin-bottom: 2.5rem;
  max-width: 500px;
  line-height: 1.7;
}

.features {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.feature-item {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.feature-title {
  font-size: 0.85rem;
  font-weight: 700;
  color: var(--accent-gold);
  text-transform: uppercase;
  letter-spacing: 0.1em;
}

.feature-desc {
  font-size: 0.9rem;
  color: var(--text-secondary);
  line-height: 1.5;
}

/* Right Side - Login Form */
.login-side {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  padding-bottom: 4rem;
}

.login-card {
  width: 100%;
  max-width: 480px;
  background: var(--glass-bg);
  backdrop-filter: blur(40px);
  border: 1px solid var(--glass-border);
  border-radius: 24px;
  padding: 3rem;
  box-shadow: 0 30px 80px rgba(0, 0, 0, 0.6);
  position: relative;
}

.login-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--accent-red), var(--accent-gold), var(--accent-jade));
  border-radius: 24px 24px 0 0;
}

.login-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.seal-icon {
  font-size: 3.5rem;
  margin-bottom: 1rem;
  filter: drop-shadow(0 0 20px var(--accent-gold));
}

.login-title {
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
  letter-spacing: -0.02em;
}

.login-subtitle {
  font-size: 0.95rem;
  color: var(--text-secondary);
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

.form-input {
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

.form-input:focus {
  background: rgba(255, 255, 255, 0.12);
  border-color: var(--accent-gold);
  transform: translateY(-2px);
  box-shadow: 0 0 20px rgba(212, 175, 55, 0.2);
}

.form-input:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.error-message {
  background: rgba(220, 38, 38, 0.15);
  border: 1px solid rgba(220, 38, 38, 0.3);
  border-radius: 8px;
  padding: 0.75rem 1rem;
  margin-bottom: 1.5rem;
  color: #ff6b6b;
  font-size: 0.9rem;
  text-align: center;
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.checkbox-wrapper {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.checkbox-wrapper input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
  accent-color: var(--accent-gold);
}

.checkbox-wrapper label {
  font-size: 0.9rem;
  color: var(--text-secondary);
  cursor: pointer;
}

.forgot-link {
  font-size: 0.9rem;
  color: var(--accent-gold);
  text-decoration: none;
  font-weight: 500;
  transition: opacity 0.3s ease;
}

.forgot-link:hover {
  opacity: 0.7;
}

.submit-btn {
  width: 100%;
  padding: 1.15rem;
  background: linear-gradient(135deg, var(--accent-gold) 0%, #b8941f 100%);
  color: var(--bg-primary);
  border: none;
  border-radius: 12px;
  font-family: 'Inter', sans-serif;
  font-size: 0.95rem;
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

.submit-btn:active:not(:disabled) {
  transform: translateY(0);
}

.submit-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.divider {
  display: flex;
  align-items: center;
  margin: 2rem 0;
}

.divider::before,
.divider::after {
  content: '';
  flex: 1;
  height: 1px;
  background: linear-gradient(to right, transparent, rgba(255, 255, 255, 0.2), transparent);
}

.divider span {
  padding: 0 1rem;
  font-size: 0.85rem;
  color: var(--text-secondary);
}

.register-link {
  text-align: center;
  font-size: 0.9rem;
  color: var(--text-secondary);
}

.register-link a {
  color: var(--accent-gold);
  text-decoration: none;
  font-weight: 600;
  transition: opacity 0.3s ease;
}

.register-link a:hover {
  opacity: 0.7;
}

/* Page Indicator */
.page-indicator {
  position: fixed;
  right: 4rem;
  top: 50%;
  transform: translateY(-50%);
  display: flex;
  flex-direction: column;
  gap: 1rem;
  z-index: 100;
}

.indicator-dot {
  width: 8px;
  height: 8px;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.3s ease;
}

.indicator-dot.active {
  background: var(--accent-gold);
  box-shadow: 0 0 15px var(--accent-gold);
  height: 28px;
  border-radius: 4px;
}

/* Responsive */
@media (max-width: 1200px) {
  .main-title {
    font-size: 5rem;
  }

  .chinese-title {
    font-size: 2.5rem;
  }
}

@media (max-width: 968px) {
  .main-container {
    grid-template-columns: 1fr;
    padding: 6rem 2rem 2rem;
  }

  .content-side {
    padding-right: 0;
    margin-bottom: 3rem;
  }

  .main-title {
    font-size: 4rem;
  }

  .features {
    grid-template-columns: 1fr;
  }

  .login-side {
    justify-content: center;
  }

  .nav-links {
    display: none;
  }

  .page-indicator {
    display: none;
  }
}

@media (max-width: 640px) {
  .navbar {
    padding: 1.5rem;
  }

  .main-container {
    padding: 6rem 1.5rem 1.5rem;
  }

  .main-title {
    font-size: 3rem;
  }

  .chinese-title {
    font-size: 2rem;
  }

  .login-card {
    padding: 2rem;
  }
}
</style>
