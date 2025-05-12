<script setup>
import { ref } from 'vue'
import { RouterView } from 'vue-router'
import Sidebar from './components/layout/Sidebar.vue'
import Header from './components/layout/Header.vue'

const isSidebarOpen = ref(true)

const toggleSidebar = () => {
  isSidebarOpen.value = !isSidebarOpen.value
}
</script>

<template>
  <div class="min-h-screen bg-gray-50 flex">
    <!-- Sidebar -->
    <Sidebar :is-open="isSidebarOpen" @toggle="toggleSidebar" />
    
    <!-- Main Content -->
    <div class="flex-1 flex flex-col transition-all duration-300 ease-in-out" :class="isSidebarOpen ? 'lg:ml-64' : 'lg:ml-20'">
      <!-- Header -->
      <Header @toggle-sidebar="toggleSidebar" />
      <!-- Page Content -->
      <main class="p-4 sm:p-6 lg:p-8 flex-1">
        <RouterView />
      </main>
    </div>
  </div>
</template>
