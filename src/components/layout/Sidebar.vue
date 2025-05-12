<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import {
  HomeIcon,
  UserGroupIcon,
  CurrencyDollarIcon,
  ChartBarIcon,
  Cog6ToothIcon,
  ChevronLeftIcon,
  ChevronRightIcon
} from '@heroicons/vue/24/outline'

const props = defineProps({
  isOpen: {
    type: Boolean,
    required: true
  }
})

const emit = defineEmits(['toggle'])

const route = useRoute()

const navigation = [
  { name: 'Dashboard', to: '/', icon: HomeIcon },
  { name: 'Contacts', to: '/contacts', icon: UserGroupIcon },
  { name: 'Deals', to: '/deals', icon: CurrencyDollarIcon },
  { name: 'Reports', to: '/reports', icon: ChartBarIcon },
  { name: 'Settings', to: '/settings', icon: Cog6ToothIcon }
]

const isActive = (path) => {
  return route.path === path
}
</script>

<template>
  <aside
    :class="[
      'fixed top-0 left-0 z-40 h-screen transition-all duration-300 ease-in-out',
      isOpen ? 'w-64' : 'w-20',
      'bg-white border-r border-gray-200'
    ]"
  >
    <!-- Logo -->
    <div class="flex items-center justify-between h-16 px-4 border-b border-gray-200">
      <div v-if="isOpen" class="text-xl font-semibold text-primary-600">
        Rylie Realty
      </div>
      <button
        @click="emit('toggle')"
        class="p-1 rounded-lg hover:bg-gray-100"
      >
        <component
          :is="isOpen ? ChevronLeftIcon : ChevronRightIcon"
          class="w-6 h-6 text-gray-500"
        />
      </button>
    </div>

    <!-- Navigation -->
    <nav class="px-2 py-4 space-y-1">
      <router-link
        v-for="item in navigation"
        :key="item.name"
        :to="item.to"
        :class="[
          'flex items-center px-3 py-2 text-sm font-medium rounded-lg transition-colors duration-200',
          isActive(item.to)
            ? 'bg-primary-50 text-primary-600'
            : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
        ]"
      >
        <component
          :is="item.icon"
          class="w-6 h-6"
          :class="isActive(item.to) ? 'text-primary-600' : 'text-gray-400'"
        />
        <span v-if="isOpen" class="ml-3">{{ item.name }}</span>
      </router-link>
    </nav>
  </aside>
</template> 