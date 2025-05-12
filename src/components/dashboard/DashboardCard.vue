<script setup>
import { computed } from 'vue'

const props = defineProps({
  title: {
    type: String,
    required: true
  },
  value: {
    type: [Number, String],
    required: true
  },
  icon: {
    type: [Object, Function],
    required: true
  },
  change: {
    type: Number,
    default: null
  },
  changeLabel: {
    type: String,
    default: 'vs last period'
  }
})

const changeColor = computed(() => {
  if (!props.change) return 'text-gray-500'
  return props.change > 0 ? 'text-green-600' : 'text-red-600'
})

const changeIcon = computed(() => {
  if (!props.change) return null
  return props.change > 0 ? '↑' : '↓'
})
</script>

<template>
  <div class="card p-6">
    <div class="flex items-center justify-between">
      <div>
        <p class="text-sm font-medium text-gray-600">{{ title }}</p>
        <p class="mt-2 text-3xl font-semibold text-gray-900">{{ value }}</p>
        
        <div v-if="change !== null" class="mt-2 flex items-center text-sm">
          <span :class="changeColor">
            {{ changeIcon }} {{ Math.abs(change) }}%
          </span>
          <span class="ml-2 text-gray-500">{{ changeLabel }}</span>
        </div>
      </div>
      
      <div class="p-3 bg-primary-50 rounded-lg">
        <component
          :is="icon"
          class="w-6 h-6 text-primary-600"
        />
      </div>
    </div>
  </div>
</template> 