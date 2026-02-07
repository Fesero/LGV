<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useAuthStore } from '../stores/auth'
import { gsap } from 'gsap'

const authStore = useAuthStore()

const currentPage = ref('home')
const showModal = ref(false)
const modalTitle = ref('')
const modalText = ref('')

const cultivatorName = computed(() => authStore.cultivatorName)

// Navigation
function navigateTo(pageName: string) {
  const currentPageEl = document.querySelector('.page.active')
  const targetPageEl = document.getElementById(pageName + 'Page')
  
  if (!targetPageEl || !currentPageEl) return

  // Animate out current page
  gsap.to(currentPageEl, {
    duration: 0.3,
    opacity: 0,
    x: -50,
    onComplete: () => {
      currentPage.value = pageName

      // Animate in new page
      gsap.fromTo(targetPageEl, 
        { opacity: 0, x: 50 },
        { duration: 0.3, opacity: 1, x: 0 }
      )
    }
  })
}

// Modal
function openModal(title: string, text: string) {
  modalTitle.value = title
  modalText.value = text
  showModal.value = true
  
  setTimeout(() => {
    const modalContent = document.querySelector('.modal-content')
    if (modalContent) {
      gsap.from(modalContent, {
        duration: 0.4,
        scale: 0.8,
        opacity: 0
      })
    }
  }, 10)
}

function closeModal() {
  const modalContent = document.querySelector('.modal-content')
  if (modalContent) {
    gsap.to(modalContent, {
      duration: 0.3,
      scale: 0.8,
      opacity: 0,
      onComplete: () => {
        showModal.value = false
      }
    })
  }
}

// Logout
async function handleLogout() {
  if (confirm('Покинуть мир культивации?')) {
    gsap.to('body', {
      duration: 0.5,
      opacity: 0,
      onComplete: async () => {
        await authStore.logout()
      }
    })
  }
}

// Custom cursor
function setupCustomCursor() {
  const cursor = document.getElementById('cursor')
  if (!cursor) return

  document.addEventListener('mousemove', (e) => {
    gsap.to(cursor, {
      duration: 0.2,
      left: e.clientX - 10,
      top: e.clientY - 10
    })
  })
}

// Animations
function setupAnimations() {
  // Hero content
  gsap.from('.hero-title', {
    duration: 1,
    y: 50,
    opacity: 0,
    delay: 0.3
  })

  gsap.from('.hero-subtitle', {
    duration: 1,
    y: 30,
    opacity: 0,
    delay: 0.5
  })

  gsap.from('.hero-stats', {
    duration: 1,
    y: 30,
    opacity: 0,
    delay: 0.7
  })

  gsap.from('.hero-actions', {
    duration: 1,
    y: 30,
    opacity: 0,
    delay: 0.9
  })

  // Card hover animations
  document.querySelectorAll('.activity-card').forEach(card => {
    card.addEventListener('mouseenter', function() {
      gsap.to(this, {
        duration: 0.3,
        scale: 1.02,
        boxShadow: '0 30px 80px rgba(0, 0, 0, 0.8)'
      })
    })

    card.addEventListener('mouseleave', function() {
      gsap.to(this, {
        duration: 0.3,
        scale: 1,
        boxShadow: '0 0 0 rgba(0, 0, 0, 0)'
      })
    })
  })

  // Technique card animations
  document.querySelectorAll('.technique-card').forEach(card => {
    card.addEventListener('mouseenter', function() {
      gsap.to(this, {
        duration: 0.3,
        y: -10,
        boxShadow: '0 25px 70px rgba(212, 175, 55, 0.4)'
      })
    })

    card.addEventListener('mouseleave', function() {
      gsap.to(this, {
        duration: 0.3,
        y: 0,
        boxShadow: '0 0 0 rgba(0, 0, 0, 0)'
      })
    })
  })

  // Button interactions
  document.querySelectorAll('button').forEach(btn => {
    btn.addEventListener('mouseenter', function() {
      gsap.to(this, { duration: 0.2, scale: 1.05 })
    })
    btn.addEventListener('mouseleave', function() {
      gsap.to(this, { duration: 0.2, scale: 1 })
    })
  })
}

onMounted(() => {
  authStore.fetchUser()
  setupCustomCursor()
  setupAnimations()
})
</script>

<template>
  <!-- Custom Cursor -->
  <div class="custom-cursor" id="cursor"></div>

  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="logo-small">☯</div>

    <nav class="nav-menu">
      <div 
        class="nav-item" 
        :class="{ active: currentPage === 'home' }"
        @click="navigateTo('home')"
      >
        <span>🏠</span>
        <div class="nav-tooltip">Главная</div>
      </div>
      <div 
        class="nav-item" 
        :class="{ active: currentPage === 'cultivation' }"
        @click="navigateTo('cultivation')"
      >
        <span>⚡</span>
        <div class="nav-tooltip">Культивация</div>
      </div>
      <div 
        class="nav-item" 
        :class="{ active: currentPage === 'techniques' }"
        @click="navigateTo('techniques')"
      >
        <span>📜</span>
        <div class="nav-tooltip">Техники</div>
      </div>
      <div 
        class="nav-item" 
        :class="{ active: currentPage === 'battles' }"
        @click="navigateTo('battles')"
      >
        <span>⚔️</span>
        <div class="nav-tooltip">Сражения</div>
      </div>
      <div 
        class="nav-item" 
        :class="{ active: currentPage === 'inventory' }"
        @click="navigateTo('inventory')"
      >
        <span>🎒</span>
        <div class="nav-tooltip">Инвентарь</div>
      </div>
      <div 
        class="nav-item" 
        :class="{ active: currentPage === 'profile' }"
        @click="navigateTo('profile')"
      >
        <span>👤</span>
        <div class="nav-tooltip">Профиль</div>
      </div>
    </nav>

    <div class="logout-icon" @click="handleLogout">
      <span>🚪</span>
    </div>
  </aside>

  <!-- Main App -->
  <main class="app-container">
    <div class="pages-container">

      <!-- Home Page -->
      <div class="page" :class="{ active: currentPage === 'home' }" id="homePage">
        <section class="hero-section">
          <div class="hero-content">
            <div class="hero-bg">
              <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2070" alt="Mountain">
            </div>
            <div class="hero-overlay"></div>

            <div style="position: relative; z-index: 10;">
              <div class="status-badge">
                <span>⚡</span>
                <span>Активный Культиватор</span>
              </div>

              <h1 class="hero-title">{{ cultivatorName }}</h1>
              <p class="hero-subtitle">
                Продолжайте свой путь к бессмертию. Развивайте силу, изучайте техники и побеждайте врагов.
              </p>

              <div class="hero-stats">
                <div class="stat-box">
                  <div class="stat-label">Уровень</div>
                  <div class="stat-value">{{ authStore.user?.character?.level || 1 }}</div>
                </div>
                <div class="stat-box">
                  <div class="stat-label">Сила</div>
                  <div class="stat-value">8,542</div>
                </div>
                <div class="stat-box">
                  <div class="stat-label">Рейтинг</div>
                  <div class="stat-value">#156</div>
                </div>
              </div>

              <div class="hero-actions">
                <button class="btn-primary" @click="navigateTo('cultivation')">
                  Культивировать
                </button>
                <button class="btn-secondary" @click="navigateTo('battles')">
                  В бой
                </button>
              </div>
            </div>
          </div>

          <div class="carousel-section">
            <div class="carousel-header">
              <h3 class="carousel-title">Последние события</h3>
              <p class="carousel-subtitle">Ваша недавняя активность</p>
            </div>

            <div class="carousel-items">
              <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1528164344705-47542687000d?q=80&w=800" alt="Battle">
                <div class="carousel-item-overlay">
                  <h4 class="carousel-item-title">Победа в дуэли</h4>
                  <p class="carousel-item-desc">Побежден Темный Меч</p>
                </div>
              </div>

              <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1454391304352-2bf4678b1a7a?q=80&w=800" alt="Cultivation">
                <div class="carousel-item-overlay">
                  <h4 class="carousel-item-title">Прорыв</h4>
                  <p class="carousel-item-desc">Достигнут {{ authStore.user?.character?.level || 1 }} уровень</p>
                </div>
              </div>

              <div class="carousel-item">
                <img src="https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=800" alt="Treasure">
                <div class="carousel-item-overlay">
                  <h4 class="carousel-item-title">Находка</h4>
                  <p class="carousel-item-desc">Найден редкий артефакт</p>
                </div>
              </div>
            </div>
          </div>
        </section>
      </div>

      <!-- Cultivation Page -->
      <div class="page" :class="{ active: currentPage === 'cultivation' }" id="cultivationPage">
        <div class="activity-grid">
          <div class="activity-card" style="color: var(--accent-gold);">
            <div class="activity-card-bg">
              <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2000" alt="Meditation">
            </div>
            <div class="activity-card-overlay">
              <div class="activity-card-icon">🧘</div>
              <h3 class="activity-card-title">Медитация</h3>
              <p class="activity-card-desc">
                Погрузитесь в глубокую медитацию для накопления энергии Ци
              </p>
              <button class="activity-card-btn" @click="openModal('Медитация', 'Начало сессии медитации...')">Начать</button>
            </div>
          </div>

          <div class="activity-card" style="color: var(--accent-red);">
            <div class="activity-card-bg">
              <img src="https://images.unsplash.com/photo-1518639192441-8fce0a366e2e?q=80&w=2000" alt="Breakthrough">
            </div>
            <div class="activity-card-overlay">
              <div class="activity-card-icon">⚡</div>
              <h3 class="activity-card-title">Прорыв</h3>
              <p class="activity-card-desc">
                Попытайтесь совершить прорыв на следующий уровень
              </p>
              <button class="activity-card-btn" @click="openModal('Прорыв', 'Подготовка к прорыву...')">Прорваться</button>
            </div>
          </div>

          <div class="activity-card" style="color: var(--accent-jade);">
            <div class="activity-card-bg">
              <img src="https://images.unsplash.com/photo-1454391304352-2bf4678b1a7a?q=80&w=2000" alt="Pills">
            </div>
            <div class="activity-card-overlay">
              <div class="activity-card-icon">💊</div>
              <h3 class="activity-card-title">Алхимия</h3>
              <p class="activity-card-desc">
                Создавайте таблетки для ускорения культивации
              </p>
              <button class="activity-card-btn" @click="openModal('Алхимия', 'Открытие печи для таблеток...')">Создать</button>
            </div>
          </div>

          <div class="activity-card" style="color: var(--accent-blue);">
            <div class="activity-card-bg">
              <img src="https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=2000" alt="Enlightenment">
            </div>
            <div class="activity-card-overlay">
              <div class="activity-card-icon">✨</div>
              <h3 class="activity-card-title">Просветление</h3>
              <p class="activity-card-desc">
                Постигайте законы неба и земли
              </p>
              <button class="activity-card-btn" @click="openModal('Просветление', 'Вход в состояние просветления...')">Постичь</button>
            </div>
          </div>
        </div>
      </div>

      <!-- Techniques Page -->
      <div class="page" :class="{ active: currentPage === 'techniques' }" id="techniquesPage">
        <div class="techniques-page">
          <div class="page-header">
            <h2 class="page-title">📜 Техники</h2>
            <p class="page-subtitle">Овладевайте мощными боевыми искусствами</p>
          </div>

          <div class="techniques-grid">
            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1525683879097-8babce140a94?q=80&w=800" alt="Fire">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Небесный Ранг</span>
                <h4 class="technique-name">🔥 Огненный Кулак Феникса</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 87%"></div>
                  </div>
                  <span class="progress-text">87%</span>
                </div>
              </div>
            </div>

            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1492011221367-f47e3ccd77a0?q=80&w=800" alt="Lightning">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Земной Ранг</span>
                <h4 class="technique-name">⚡ Танец Молнии</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 65%"></div>
                  </div>
                  <span class="progress-text">65%</span>
                </div>
              </div>
            </div>

            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1505142468610-359e7d316be0?q=80&w=800" alt="Water">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Земной Ранг</span>
                <h4 class="technique-name">🌊 Волны Моря</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 42%"></div>
                  </div>
                  <span class="progress-text">42%</span>
                </div>
              </div>
            </div>

            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=800" alt="Wind">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Небесный Ранг</span>
                <h4 class="technique-name">💨 Шаги Ветра</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 93%"></div>
                  </div>
                  <span class="progress-text">93%</span>
                </div>
              </div>
            </div>

            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1518639192441-8fce0a366e2e?q=80&w=800" alt="Earth">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Смертный Ранг</span>
                <h4 class="technique-name">🗻 Щит Горы</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 76%"></div>
                  </div>
                  <span class="progress-text">76%</span>
                </div>
              </div>
            </div>

            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1454391304352-2bf4678b1a7a?q=80&w=800" alt="Sword">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Божественный</span>
                <h4 class="technique-name">⚔️ Меч Разрушения</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 28%"></div>
                  </div>
                  <span class="progress-text">28%</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Battles Page -->
      <div class="page" :class="{ active: currentPage === 'battles' }" id="battlesPage">
        <div class="activity-grid">
          <div class="activity-card" style="color: var(--accent-red);">
            <div class="activity-card-bg">
              <img src="https://images.unsplash.com/photo-1528164344705-47542687000d?q=80&w=2000" alt="Arena">
            </div>
            <div class="activity-card-overlay">
              <div class="activity-card-icon">⚔️</div>
              <h3 class="activity-card-title">Арена</h3>
              <p class="activity-card-desc">
                Сражайтесь с другими культиваторами за славу и награды
              </p>
              <button class="activity-card-btn">Вступить</button>
            </div>
          </div>

          <div class="activity-card" style="color: var(--accent-purple);">
            <div class="activity-card-bg">
              <img src="https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=2000" alt="Dungeon">
            </div>
            <div class="activity-card-overlay">
              <div class="activity-card-icon">🏰</div>
              <h3 class="activity-card-title">Подземелья</h3>
              <p class="activity-card-desc">
                Исследуйте опасные локации в поисках сокровищ
              </p>
              <button class="activity-card-btn">Войти</button>
            </div>
          </div>

          <div class="activity-card" style="color: var(--accent-jade);">
            <div class="activity-card-bg">
              <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2000" alt="Boss">
            </div>
            <div class="activity-card-overlay">
              <div class="activity-card-icon">👹</div>
              <h3 class="activity-card-title">Мировые Боссы</h3>
              <p class="activity-card-desc">
                Объединяйтесь для битвы с могущественными существами
              </p>
              <button class="activity-card-btn">Присоединиться</button>
            </div>
          </div>

          <div class="activity-card" style="color: var(--accent-gold);">
            <div class="activity-card-bg">
              <img src="https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=2000" alt="Tournament">
            </div>
            <div class="activity-card-overlay">
              <div class="activity-card-icon">🏆</div>
              <h3 class="activity-card-title">Турнир</h3>
              <p class="activity-card-desc">
                Участвуйте в ежемесячном турнире сильнейших
              </p>
              <button class="activity-card-btn">Зарегистрироваться</button>
            </div>
          </div>
        </div>
      </div>

      <!-- Inventory Page -->
      <div class="page" :class="{ active: currentPage === 'inventory' }" id="inventoryPage">
        <div class="techniques-page">
          <div class="page-header">
            <h2 class="page-title">🎒 Инвентарь</h2>
            <p class="page-subtitle">Управляйте своими артефактами и ресурсами</p>
          </div>

          <div class="techniques-grid">
            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1454391304352-2bf4678b1a7a?q=80&w=800" alt="Sword">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Легендарный</span>
                <h4 class="technique-name">⚔️ Меч Дракона</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 100%"></div>
                  </div>
                  <span class="progress-text">+2547 Атаки</span>
                </div>
              </div>
            </div>

            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1518639192441-8fce0a366e2e?q=80&w=800" alt="Armor">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Эпический</span>
                <h4 class="technique-name">🛡️ Доспех Феникса</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 100%; background: var(--accent-jade);"></div>
                  </div>
                  <span class="progress-text">+1892 Защиты</span>
                </div>
              </div>
            </div>

            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1525683879097-8babce140a94?q=80&w=800" alt="Ring">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Божественный</span>
                <h4 class="technique-name">💍 Кольцо Вечности</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 100%; background: var(--accent-purple);"></div>
                  </div>
                  <span class="progress-text">+500 Ци/мин</span>
                </div>
              </div>
            </div>

            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=800" alt="Pills">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Редкий</span>
                <h4 class="technique-name">💊 Таблетки Прорыва</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 100%; background: var(--accent-red);"></div>
                  </div>
                  <span class="progress-text">x47 в наличии</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Profile Page -->
      <div class="page" :class="{ active: currentPage === 'profile' }" id="profilePage">
        <div class="profile-page">
          <div class="profile-hero">
            <img src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2000" alt="Profile Background" class="profile-hero-bg">
            <div class="profile-hero-content">
              <div class="profile-rank">S-Ранг Культиватор • Внутренний Ученик</div>
              <h2 class="profile-name">{{ cultivatorName }}</h2>
              <div class="profile-stats-row">
                <div class="profile-stat">
                  <span class="profile-stat-value">{{ authStore.user?.character?.level || 1 }}</span>
                  <span class="profile-stat-label">Уровень</span>
                </div>
                <div class="profile-stat">
                  <span class="profile-stat-value">8,542</span>
                  <span class="profile-stat-label">Боевая Мощь</span>
                </div>
                <div class="profile-stat">
                  <span class="profile-stat-value">#156</span>
                  <span class="profile-stat-label">Рейтинг</span>
                </div>
                <div class="profile-stat">
                  <span class="profile-stat-value">24</span>
                  <span class="profile-stat-label">Техник</span>
                </div>
              </div>
            </div>
          </div>

          <div class="techniques-grid">
            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=800" alt="Achievements">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Достижения</span>
                <h4 class="technique-name">🏆 128 получено</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 64%"></div>
                  </div>
                  <span class="progress-text">64%</span>
                </div>
              </div>
            </div>

            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1528164344705-47542687000d?q=80&w=800" alt="Battles">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Сражения</span>
                <h4 class="technique-name">⚔️ 847 побед</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 87%; background: var(--accent-red);"></div>
                  </div>
                  <span class="progress-text">87% винрейт</span>
                </div>
              </div>
            </div>

            <div class="technique-card">
              <div class="technique-card-bg">
                <img src="https://images.unsplash.com/photo-1519681393784-d120267933ba?q=80&w=800" alt="Time">
              </div>
              <div class="technique-card-content">
                <span class="technique-rank">Активность</span>
                <h4 class="technique-name">⏰ 847 часов</h4>
                <div class="technique-progress">
                  <div class="progress-bar">
                    <div class="progress-fill" style="width: 100%; background: var(--accent-jade);"></div>
                  </div>
                  <span class="progress-text">Всего времени</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  </main>

  <!-- Modal -->
  <div class="modal" :class="{ active: showModal }">
    <div class="modal-content">
      <div class="modal-close" @click="closeModal">×</div>
      <h2>{{ modalTitle }}</h2>
      <p>{{ modalText }}</p>
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
  --bg-secondary: #151515;
  --text-primary: #ffffff;
  --text-secondary: #a0a0a0;
  --accent-gold: #d4af37;
  --accent-red: #dc2626;
  --accent-jade: #10b981;
  --accent-blue: #3b82f6;
  --accent-purple: #8b5cf6;
}

/* Cursor */
.custom-cursor {
  width: 20px;
  height: 20px;
  border: 2px solid var(--accent-gold);
  border-radius: 50%;
  position: fixed;
  pointer-events: none;
  z-index: 9999;
  transition: transform 0.2s ease;
  mix-blend-mode: difference;
}

/* Sidebar Navigation */
.sidebar {
  position: fixed;
  left: 0;
  top: 0;
  width: 90px;
  height: 100vh;
  background: rgba(10, 10, 10, 0.8);
  backdrop-filter: blur(20px);
  border-right: 1px solid rgba(255, 255, 255, 0.1);
  z-index: 1000;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2rem 0;
}

.logo-small {
  font-size: 2.5rem;
  color: var(--accent-gold);
  margin-bottom: 3rem;
  cursor: pointer;
  transition: transform 0.3s ease;
}

.logo-small:hover {
  transform: scale(1.1) rotate(180deg);
}

.nav-menu {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.nav-item {
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  color: var(--text-secondary);
  cursor: pointer;
  border-radius: 12px;
  transition: all 0.3s ease;
  position: relative;
}

.nav-item:hover {
  color: var(--accent-gold);
  background: rgba(212, 175, 55, 0.1);
  transform: translateX(5px);
}

.nav-item.active {
  color: var(--accent-gold);
  background: rgba(212, 175, 55, 0.2);
}

.nav-item.active::before {
  content: '';
  position: absolute;
  left: -15px;
  width: 3px;
  height: 100%;
  background: var(--accent-gold);
  box-shadow: 0 0 10px var(--accent-gold);
}

.nav-tooltip {
  position: absolute;
  left: 70px;
  background: rgba(10, 10, 10, 0.95);
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-size: 0.9rem;
  white-space: nowrap;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease;
  border: 1px solid rgba(212, 175, 55, 0.3);
}

.nav-item:hover .nav-tooltip {
  opacity: 1;
}

.logout-icon {
  width: 50px;
  height: 50px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  color: var(--accent-red);
  cursor: pointer;
  border-radius: 12px;
  transition: all 0.3s ease;
}

.logout-icon:hover {
  background: rgba(220, 38, 38, 0.2);
  transform: scale(1.1);
}

/* Main App Container */
.app-container {
  margin-left: 90px;
  height: 100vh;
  overflow: hidden;
  position: relative;
}

/* Pages Container */
.pages-container {
  position: relative;
  width: 100%;
  height: 100%;
}

.page {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.5s ease;
}

.page.active {
  opacity: 1;
  pointer-events: all;
}

/* Hero Section */
.hero-section {
  position: relative;
  width: 100%;
  height: 100%;
  display: grid;
  grid-template-columns: 1fr 400px;
  overflow: hidden;
}

.hero-content {
  padding: 4rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
  position: relative;
  z-index: 10;
}

.hero-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
}

.hero-bg img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  filter: brightness(0.4);
}

.hero-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(10, 10, 10, 0.9) 0%, rgba(10, 10, 10, 0.6) 50%, transparent 100%);
  z-index: 1;
}

.status-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  background: rgba(212, 175, 55, 0.15);
  border: 1px solid rgba(212, 175, 55, 0.3);
  border-radius: 50px;
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--accent-gold);
  margin-bottom: 2rem;
  width: fit-content;
  backdrop-filter: blur(10px);
}

.hero-title {
  font-family: 'Noto Serif SC', serif;
  font-size: 6rem;
  font-weight: 900;
  line-height: 1;
  margin-bottom: 1.5rem;
  background: linear-gradient(135deg, #ffffff 0%, var(--accent-gold) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero-subtitle {
  font-size: 1.5rem;
  color: var(--text-secondary);
  margin-bottom: 3rem;
  max-width: 600px;
  line-height: 1.6;
}

.hero-stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
  margin-bottom: 3rem;
}

.stat-box {
  position: relative;
}

.stat-label {
  font-size: 0.85rem;
  color: var(--text-secondary);
  margin-bottom: 0.5rem;
  text-transform: uppercase;
  letter-spacing: 0.1em;
}

.stat-value {
  font-size: 2.5rem;
  font-weight: 800;
  background: linear-gradient(135deg, var(--accent-gold) 0%, #ffffff 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.hero-actions {
  display: flex;
  gap: 1.5rem;
}

.btn-primary {
  padding: 1.25rem 3rem;
  background: linear-gradient(135deg, var(--accent-gold) 0%, #b8941f 100%);
  border: none;
  border-radius: 12px;
  color: var(--bg-primary);
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s ease;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  box-shadow: 0 10px 30px rgba(212, 175, 55, 0.3);
}

.btn-primary:hover {
  transform: translateY(-3px);
  box-shadow: 0 15px 40px rgba(212, 175, 55, 0.5);
}

.btn-secondary {
  padding: 1.25rem 3rem;
  background: rgba(255, 255, 255, 0.05);
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  color: var(--text-primary);
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s ease;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  backdrop-filter: blur(10px);
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: var(--accent-gold);
  transform: translateY(-3px);
}

/* Carousel Section */
.carousel-section {
  background: rgba(10, 10, 10, 0.8);
  backdrop-filter: blur(20px);
  border-left: 1px solid rgba(255, 255, 255, 0.1);
  padding: 2rem;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
}

.carousel-header {
  margin-bottom: 2rem;
}

.carousel-title {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.carousel-subtitle {
  font-size: 0.9rem;
  color: var(--text-secondary);
}

.carousel-items {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.carousel-item {
  position: relative;
  height: 200px;
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
}

.carousel-item:hover {
  transform: translateX(-10px);
}

.carousel-item img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.carousel-item:hover img {
  transform: scale(1.1);
}

.carousel-item-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 1.5rem;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.95), transparent);
}

.carousel-item-title {
  font-size: 1.1rem;
  font-weight: 700;
  margin-bottom: 0.25rem;
}

.carousel-item-desc {
  font-size: 0.85rem;
  color: var(--text-secondary);
}

/* Activity Grid Page */
.activity-grid {
  padding: 3rem;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
  gap: 2rem;
  height: 100%;
  overflow-y: auto;
}

.activity-card {
  position: relative;
  height: 400px;
  border-radius: 24px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.activity-card:hover {
  transform: translateY(-10px);
}

.activity-card-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.activity-card-bg img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  filter: brightness(0.6);
  transition: transform 0.5s ease;
}

.activity-card:hover .activity-card-bg img {
  transform: scale(1.05);
  filter: brightness(0.7);
}

.activity-card-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, rgba(10, 10, 10, 0.5) 0%, rgba(10, 10, 10, 0.8) 100%);
  padding: 2.5rem;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
}

.activity-card-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
  filter: drop-shadow(0 0 20px currentColor);
}

.activity-card-title {
  font-size: 2.5rem;
  font-weight: 900;
  margin-bottom: 1rem;
  text-transform: uppercase;
  letter-spacing: -0.02em;
}

.activity-card-desc {
  font-size: 1rem;
  color: var(--text-secondary);
  margin-bottom: 2rem;
  line-height: 1.6;
}

.activity-card-btn {
  padding: 1rem 2rem;
  background: rgba(255, 255, 255, 0.1);
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 12px;
  color: var(--text-primary);
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s ease;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  width: fit-content;
  backdrop-filter: blur(10px);
}

.activity-card-btn:hover {
  background: var(--accent-gold);
  border-color: var(--accent-gold);
  color: var(--bg-primary);
  transform: translateX(10px);
}

/* Techniques Page */
.techniques-page {
  padding: 3rem;
  height: 100%;
  overflow-y: auto;
}

.page-header {
  margin-bottom: 3rem;
}

.page-title {
  font-size: 3.5rem;
  font-weight: 900;
  margin-bottom: 1rem;
  background: linear-gradient(135deg, var(--accent-gold) 0%, #ffffff 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.page-subtitle {
  font-size: 1.2rem;
  color: var(--text-secondary);
}

.techniques-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 2rem;
}

.technique-card {
  position: relative;
  height: 280px;
  border-radius: 20px;
  overflow: hidden;
  cursor: pointer;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.4s ease;
}

.technique-card:hover {
  transform: translateY(-5px);
  border-color: var(--accent-gold);
  box-shadow: 0 20px 60px rgba(212, 175, 55, 0.3);
}

.technique-card-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 60%;
  overflow: hidden;
}

.technique-card-bg img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  filter: brightness(0.7);
  transition: transform 0.5s ease;
}

.technique-card:hover .technique-card-bg img {
  transform: scale(1.1);
}

.technique-card-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 1.5rem;
  background: linear-gradient(to top, rgba(10, 10, 10, 0.98) 70%, transparent);
}

.technique-rank {
  display: inline-block;
  padding: 0.35rem 0.75rem;
  background: rgba(212, 175, 55, 0.2);
  border: 1px solid var(--accent-gold);
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 700;
  color: var(--accent-gold);
  margin-bottom: 0.75rem;
  text-transform: uppercase;
}

.technique-name {
  font-size: 1.3rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.technique-progress {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 1rem;
}

.progress-bar {
  flex: 1;
  height: 6px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 3px;
  overflow: hidden;
  margin-right: 1rem;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--accent-gold) 0%, #b8941f 100%);
  border-radius: 3px;
  box-shadow: 0 0 10px var(--accent-gold);
}

.progress-text {
  font-size: 0.9rem;
  font-weight: 700;
  color: var(--accent-gold);
}

/* Profile Page */
.profile-page {
  padding: 3rem;
  height: 100%;
  overflow-y: auto;
}

.profile-hero {
  position: relative;
  height: 400px;
  border-radius: 24px;
  overflow: hidden;
  margin-bottom: 3rem;
}

.profile-hero-bg {
  width: 100%;
  height: 100%;
  object-fit: cover;
  filter: brightness(0.5);
}

.profile-hero-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 3rem;
  background: linear-gradient(to top, rgba(10, 10, 10, 0.95) 50%, transparent);
}

.profile-rank {
  font-size: 1rem;
  color: var(--accent-gold);
  margin-bottom: 1rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.15em;
}

.profile-name {
  font-size: 4rem;
  font-weight: 900;
  margin-bottom: 1rem;
  font-family: 'Noto Serif SC', serif;
}

.profile-stats-row {
  display: flex;
  gap: 3rem;
}

.profile-stat {
  display: flex;
  flex-direction: column;
}

.profile-stat-value {
  font-size: 2rem;
  font-weight: 800;
  color: var(--accent-gold);
}

.profile-stat-label {
  font-size: 0.9rem;
  color: var(--text-secondary);
  text-transform: uppercase;
}

/* Modal */
.modal {
  position: fixed;
  top: 0;
  left: 90px;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.95);
  backdrop-filter: blur(20px);
  z-index: 2000;
  display: none;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}

.modal.active {
  display: flex;
}

.modal-content {
  max-width: 800px;
  width: 100%;
  background: rgba(20, 20, 20, 0.95);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 24px;
  padding: 3rem;
  position: relative;
}

.modal-close {
  position: absolute;
  top: 2rem;
  right: 2rem;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 1.5rem;
}

.modal-close:hover {
  background: var(--accent-red);
  transform: rotate(90deg);
}

/* Responsive */
@media (max-width: 1400px) {
  .hero-section {
    grid-template-columns: 1fr;
  }

  .carousel-section {
    display: none;
  }
}

@media (max-width: 968px) {
  .sidebar {
    bottom: 0;
    top: auto;
    width: 100%;
    height: 80px;
    flex-direction: row;
    padding: 0 2rem;
  }

  .app-container {
    margin-left: 0;
    margin-bottom: 80px;
  }

  .hero-title {
    font-size: 3.5rem;
  }

  .activity-grid {
    grid-template-columns: 1fr;
  }
}

/* Scrollbar */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
}

::-webkit-scrollbar-thumb {
  background: var(--accent-gold);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #b8941f;
}
</style>
