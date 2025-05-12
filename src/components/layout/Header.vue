<script setup>
import { ref } from 'vue'
import {
  Bars3Icon,
  BellIcon,
  MagnifyingGlassIcon
} from '@heroicons/vue/24/outline'

const emit = defineEmits(['toggle-sidebar'])

const notifications = ref([
  { id: 1, message: 'New contact added', time: '5 minutes ago' },
  { id: 2, message: 'Deal closed: Project X', time: '1 hour ago' },
  { id: 3, message: 'Meeting reminder: Team sync', time: '2 hours ago' }
])

const showNotifications = ref(false)
const showProfileMenu = ref(false)

const toggleNotifications = () => {
  showNotifications.value = !showNotifications.value
  showProfileMenu.value = false
}

const toggleProfileMenu = () => {
  showProfileMenu.value = !showProfileMenu.value
  showNotifications.value = false
}
</script>

<template>
  <header class="sticky top-0 z-30 bg-white border-b border-gray-200">
    <div class="flex items-center justify-between h-16 px-4 sm:px-6 lg:px-8">
      <!-- Left side -->
      <div class="flex items-center">
        <button
          @click="emit('toggle-sidebar')"
          class="p-2 text-gray-500 rounded-lg lg:hidden hover:bg-gray-100"
        >
          <Bars3Icon class="w-6 h-6" />
        </button>
        
        <!-- Search -->
        <div class="hidden sm:flex items-center ml-4">
          <div class="relative">
            <input
              type="text"
              placeholder="Search..."
              class="input pl-10 w-64"
            />
            <MagnifyingGlassIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
          </div>
        </div>
      </div>

      <!-- Right side -->
      <div class="flex items-center space-x-4">
        <!-- Notifications -->
        <div class="relative">
          <button
            @click="toggleNotifications"
            class="p-2 text-gray-500 rounded-lg hover:bg-gray-100"
          >
            <BellIcon class="w-6 h-6" />
            <span class="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
          </button>

          <!-- Notifications dropdown -->
          <div
            v-if="showNotifications"
            class="absolute right-0 mt-2 w-80 bg-white rounded-lg shadow-lg border border-gray-200 py-1"
          >
            <div class="px-4 py-2 border-b border-gray-200">
              <h3 class="text-sm font-medium text-gray-900">Notifications</h3>
            </div>
            <div class="max-h-96 overflow-y-auto">
              <a
                v-for="notification in notifications"
                :key="notification.id"
                href="#"
                class="block px-4 py-3 hover:bg-gray-50"
              >
                <p class="text-sm text-gray-900">{{ notification.message }}</p>
                <p class="text-xs text-gray-500 mt-1">{{ notification.time }}</p>
              </a>
            </div>
          </div>
        </div>

        <!-- Profile -->
        <div class="relative">
          <button
            @click="toggleProfileMenu"
            class="flex items-center space-x-3 focus:outline-none"
          >
            <img
              src="https://ui-avatars.com/api/?name=Rylie+Vaughn&background=0D8ABC&color=fff"
              alt="Profile"
              class="w-8 h-8 rounded-full"
            />
            <span class="hidden sm:block text-sm font-medium text-gray-700">Rylie Vaughn</span>
          </button>

          <!-- Profile dropdown -->
          <div
            v-if="showProfileMenu"
            class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-1"
          >
            <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">Your Profile</a>
            <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">Settings</a>
            <div class="border-t border-gray-200"></div>
            <a href="#" class="block px-4 py-2 text-sm text-red-600 hover:bg-gray-50">Sign out</a>
          </div>
        </div>
      </div>
    </div>
  </header>
</template> 