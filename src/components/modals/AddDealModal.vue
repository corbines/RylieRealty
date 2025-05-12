<script setup>
import { ref } from 'vue'
import { XMarkIcon } from '@heroicons/vue/24/outline'

const props = defineProps({
  isOpen: {
    type: Boolean,
    required: true
  }
})

const emit = defineEmits(['close', 'submit'])

const formData = ref({
  name: '',
  value: '',
  stage: 'prospecting',
  expectedCloseDate: '',
  contactId: '',
  company: '',
  description: '',
  probability: 0
})

const stages = [
  { value: 'prospecting', label: 'Prospecting' },
  { value: 'qualification', label: 'Qualification' },
  { value: 'proposal', label: 'Proposal' },
  { value: 'negotiation', label: 'Negotiation' },
  { value: 'closed_won', label: 'Closed Won' },
  { value: 'closed_lost', label: 'Closed Lost' }
]

const handleSubmit = () => {
  // Convert value to number and probability to percentage
  const submitData = {
    ...formData.value,
    value: parseFloat(formData.value.value.replace(/[^0-9.-]+/g, '')) || 0,
    probability: formData.value.probability / 100
  }
  emit('submit', submitData)
  // Reset form
  Object.keys(formData.value).forEach(key => {
    formData.value[key] = key === 'stage' ? 'prospecting' : key === 'probability' ? 0 : ''
  })
  emit('close')
}
</script>

<template>
  <div v-if="isOpen" class="fixed inset-0 z-50 overflow-y-auto">
    <!-- Backdrop -->
    <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" @click="emit('close')"></div>

    <!-- Modal -->
    <div class="flex min-h-full items-center justify-center p-4">
      <div class="relative w-full max-w-lg bg-white rounded-lg shadow-xl">
        <!-- Header -->
        <div class="flex items-center justify-between p-6 border-b border-gray-200">
          <h3 class="text-lg font-medium text-gray-900">Add New Deal</h3>
          <button
            @click="emit('close')"
            class="text-gray-400 hover:text-gray-500"
          >
            <XMarkIcon class="w-6 h-6" />
          </button>
        </div>

        <!-- Form -->
        <form @submit.prevent="handleSubmit" class="p-6 space-y-4">
          <div>
            <label for="name" class="block text-sm font-medium text-gray-700">Deal Name</label>
            <input
              type="text"
              id="name"
              v-model="formData.name"
              class="mt-1 input w-full"
              required
            />
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div>
              <label for="value" class="block text-sm font-medium text-gray-700">Deal Value</label>
              <div class="mt-1 relative rounded-md shadow-sm">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <span class="text-gray-500 sm:text-sm">$</span>
                </div>
                <input
                  type="text"
                  id="value"
                  v-model="formData.value"
                  class="input pl-7 w-full"
                  placeholder="0.00"
                  required
                />
              </div>
            </div>

            <div>
              <label for="probability" class="block text-sm font-medium text-gray-700">Probability</label>
              <div class="mt-1 relative rounded-md shadow-sm">
                <input
                  type="number"
                  id="probability"
                  v-model="formData.probability"
                  min="0"
                  max="100"
                  class="input pr-7 w-full"
                  required
                />
                <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                  <span class="text-gray-500 sm:text-sm">%</span>
                </div>
              </div>
            </div>
          </div>

          <div>
            <label for="stage" class="block text-sm font-medium text-gray-700">Stage</label>
            <select
              id="stage"
              v-model="formData.stage"
              class="mt-1 input w-full"
              required
            >
              <option v-for="stage in stages" :key="stage.value" :value="stage.value">
                {{ stage.label }}
              </option>
            </select>
          </div>

          <div>
            <label for="expectedCloseDate" class="block text-sm font-medium text-gray-700">Expected Close Date</label>
            <input
              type="date"
              id="expectedCloseDate"
              v-model="formData.expectedCloseDate"
              class="mt-1 input w-full"
              required
            />
          </div>

          <div>
            <label for="company" class="block text-sm font-medium text-gray-700">Company</label>
            <input
              type="text"
              id="company"
              v-model="formData.company"
              class="mt-1 input w-full"
              required
            />
          </div>

          <div>
            <label for="contactId" class="block text-sm font-medium text-gray-700">Primary Contact</label>
            <input
              type="text"
              id="contactId"
              v-model="formData.contactId"
              class="mt-1 input w-full"
              placeholder="Search contacts..."
            />
          </div>

          <div>
            <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
            <textarea
              id="description"
              v-model="formData.description"
              rows="3"
              class="mt-1 input w-full"
            ></textarea>
          </div>

          <!-- Footer -->
          <div class="flex justify-end space-x-3 pt-4 border-t border-gray-200">
            <button
              type="button"
              @click="emit('close')"
              class="btn btn-secondary"
            >
              Cancel
            </button>
            <button
              type="submit"
              class="btn btn-primary"
            >
              Add Deal
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template> 