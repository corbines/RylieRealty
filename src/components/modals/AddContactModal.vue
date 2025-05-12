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
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  company: '',
  title: '',
  notes: ''
})

const handleSubmit = () => {
  emit('submit', { ...formData.value })
  // Reset form
  Object.keys(formData.value).forEach(key => {
    formData.value[key] = ''
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
          <h3 class="text-lg font-medium text-gray-900">Add New Contact</h3>
          <button
            @click="emit('close')"
            class="text-gray-400 hover:text-gray-500"
          >
            <XMarkIcon class="w-6 h-6" />
          </button>
        </div>

        <!-- Form -->
        <form @submit.prevent="handleSubmit" class="p-6 space-y-4">
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label for="firstName" class="block text-sm font-medium text-gray-700">First Name</label>
              <input
                type="text"
                id="firstName"
                v-model="formData.firstName"
                class="mt-1 input w-full"
                required
              />
            </div>
            <div>
              <label for="lastName" class="block text-sm font-medium text-gray-700">Last Name</label>
              <input
                type="text"
                id="lastName"
                v-model="formData.lastName"
                class="mt-1 input w-full"
                required
              />
            </div>
          </div>

          <div>
            <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
            <input
              type="email"
              id="email"
              v-model="formData.email"
              class="mt-1 input w-full"
              required
            />
          </div>

          <div>
            <label for="phone" class="block text-sm font-medium text-gray-700">Phone</label>
            <input
              type="tel"
              id="phone"
              v-model="formData.phone"
              class="mt-1 input w-full"
            />
          </div>

          <div>
            <label for="company" class="block text-sm font-medium text-gray-700">Company</label>
            <input
              type="text"
              id="company"
              v-model="formData.company"
              class="mt-1 input w-full"
            />
          </div>

          <div>
            <label for="title" class="block text-sm font-medium text-gray-700">Job Title</label>
            <input
              type="text"
              id="title"
              v-model="formData.title"
              class="mt-1 input w-full"
            />
          </div>

          <div>
            <label for="notes" class="block text-sm font-medium text-gray-700">Notes</label>
            <textarea
              id="notes"
              v-model="formData.notes"
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
              Add Contact
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template> 