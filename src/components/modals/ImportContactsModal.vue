<script setup>
import { ref, computed } from 'vue'
import { XMarkIcon, DocumentArrowUpIcon } from '@heroicons/vue/24/outline'

const props = defineProps({
  isOpen: {
    type: Boolean,
    required: true
  }
})

const emit = defineEmits(['close', 'import-complete'])

const file = ref(null)
const isUploading = ref(false)
const error = ref(null)
const success = ref(false)
const showMapping = ref(false)
const csvHeaders = ref([])
const csvPreview = ref([])
const columnMapping = ref({})

// Define required fields and their database column names
const requiredFields = [
  { label: 'First Name', dbField: 'first_name', required: true },
  { label: 'Last Name', dbField: 'last_name', required: true },
  { label: 'Email Address', dbField: 'email', required: true },
  { label: 'Phone', dbField: 'phone', required: false },
  { label: 'Mobile', dbField: 'mobile', required: false },
  { label: 'Company', dbField: 'company', required: false },
  { label: 'Street Address', dbField: 'street_address', required: false },
  { label: 'City', dbField: 'city', required: false },
  { label: 'State', dbField: 'state', required: false },
  { label: 'Country', dbField: 'country', required: false },
  { label: 'ZIP/Postcode', dbField: 'zip_postcode', required: false },
  { label: 'Subscription Date', dbField: 'subscription_date', required: false },
  { label: 'Unsubscription Date', dbField: 'unsubscription_date', required: false },
  { label: 'Unsubscribed Reason', dbField: 'unsubscribed_reason', required: false },
  { label: 'Subscription Status (Email)', dbField: 'subscription_status_email', required: false },
  { label: 'Subscription Status (SMS)', dbField: 'subscription_status_sms', required: false },
  { label: 'Source', dbField: 'source', required: false },
  { label: 'Site Source', dbField: 'site_source', required: false },
  { label: 'Sub Source', dbField: 'sub_source', required: false },
  { label: 'Buyer Preference', dbField: 'buyer_preference', required: false },
  { label: 'Birthday', dbField: 'birthday', required: false },
  { label: 'Latest Interaction', dbField: 'latest_interaction', required: false },
  { label: 'Tags', dbField: 'tags', required: false }
]

// Computed property to check if all required fields are mapped
const isMappingValid = computed(() => {
  const requiredMappings = requiredFields
    .filter(field => field.required)
    .map(field => columnMapping.value[field.dbField])
  
  return requiredMappings.every(mapping => mapping && mapping !== '')
})

const handleFileChange = async (event) => {
  const selectedFile = event.target.files[0]
  if (selectedFile && selectedFile.type === 'text/csv') {
    file.value = selectedFile
    error.value = null
    
    // Read and parse CSV to get headers and preview
    try {
      const text = await selectedFile.text()
      const lines = text.split('\n')
      const headers = lines[0].split(',').map(h => h.trim())
      const preview = lines.slice(1, 6).map(line => {
        const values = line.split(',').map(v => v.trim())
        return headers.reduce((obj, header, index) => {
          obj[header] = values[index] || ''
          return obj
        }, {})
      })

      csvHeaders.value = headers
      csvPreview.value = preview
      showMapping.value = true

      // Initialize column mapping with empty values
      columnMapping.value = requiredFields.reduce((acc, field) => {
        acc[field.dbField] = ''
        return acc
      }, {})

      // Try to auto-map columns based on exact matches
      headers.forEach(header => {
        const matchingField = requiredFields.find(field => 
          field.label.toLowerCase() === header.toLowerCase()
        )
        if (matchingField) {
          columnMapping.value[matchingField.dbField] = header
        }
      })
    } catch (err) {
      error.value = 'Error reading CSV file: ' + err.message
      file.value = null
      showMapping.value = false
    }
  } else {
    error.value = 'Please select a valid CSV file'
    file.value = null
    showMapping.value = false
  }
}

const handleSubmit = async () => {
  if (!file.value) {
    error.value = 'Please select a file to upload'
    return
  }

  if (!isMappingValid.value) {
    error.value = 'Please map all required fields'
    return
  }

  isUploading.value = true
  error.value = null
  success.value = null

  const formData = new FormData()
  formData.append('file', file.value)
  formData.append('mapping', JSON.stringify(columnMapping.value))

  try {
    const response = await fetch('http://localhost:3001/api/contacts/import', {
      method: 'POST',
      body: formData
    })

    const result = await response.json()

    if (!response.ok) {
      throw new Error(result.error || 'Failed to import contacts')
    }

    success.value = result.message
    emit('import-complete', result.imported)
    
    // Reset form
    file.value = null
    showMapping.value = false
    if (document.querySelector('input[type="file"]')) {
      document.querySelector('input[type="file"]').value = ''
    }
  } catch (err) {
    error.value = err.message
  } finally {
    isUploading.value = false
  }
}

const downloadTemplate = () => {
  const headers = [
    'First Name',
    'Last Name',
    'Email Address',
    'Phone',
    'Mobile',
    'Company',
    'Street Address',
    'City',
    'State',
    'Country',
    'ZIP/Postcode',
    'Subscription Date',
    'Unsubscription Date',
    'Unsubscribed Reason',
    'Subscription Status (Email)',
    'Subscription Status (SMS)',
    'Source',
    'Site Source',
    'Sub Source',
    'Buyer Preference',
    'Birthday',
    'Latest Interaction',
    'Tags'
  ].join(',')

  const blob = new Blob([headers], { type: 'text/csv' })
  const url = window.URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = 'contacts_template.csv'
  document.body.appendChild(a)
  a.click()
  window.URL.revokeObjectURL(url)
  document.body.removeChild(a)
}
</script>

<template>
  <div v-if="isOpen" class="fixed inset-0 z-50 overflow-y-auto">
    <!-- Backdrop -->
    <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity" @click="emit('close')"></div>

    <!-- Modal -->
    <div class="flex min-h-full items-center justify-center p-4">
      <div class="relative w-full max-w-4xl bg-white rounded-lg shadow-xl">
        <!-- Header -->
        <div class="flex items-center justify-between p-6 border-b border-gray-200">
          <h3 class="text-lg font-medium text-gray-900">Import Contacts</h3>
          <button
            @click="emit('close')"
            class="text-gray-400 hover:text-gray-500"
          >
            <XMarkIcon class="w-6 h-6" />
          </button>
        </div>

        <!-- Content -->
        <div class="p-6 space-y-4">
          <!-- Instructions -->
          <div class="text-sm text-gray-500">
            <p>Upload a CSV file containing your contacts. The file should include the following required columns:</p>
            <ul class="mt-2 list-disc list-inside">
              <li v-for="field in requiredFields.filter(f => f.required)" :key="field.dbField">
                {{ field.label }}
              </li>
            </ul>
          </div>

          <!-- Download Template -->
          <button
            @click="downloadTemplate"
            class="text-sm text-primary-600 hover:text-primary-700"
          >
            Download CSV Template
          </button>

          <!-- File Upload -->
          <div class="mt-4">
            <label
              class="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100"
              :class="{ 'border-primary-500': file }"
            >
              <div class="flex flex-col items-center justify-center pt-5 pb-6">
                <DocumentArrowUpIcon class="w-8 h-8 mb-2 text-gray-500" />
                <p class="mb-2 text-sm text-gray-500">
                  <span class="font-semibold">Click to upload</span> or drag and drop
                </p>
                <p class="text-xs text-gray-500">CSV file only</p>
              </div>
              <input
                type="file"
                class="hidden"
                accept=".csv"
                @change="handleFileChange"
              />
            </label>
            <p v-if="file" class="mt-2 text-sm text-gray-500">
              Selected file: {{ file.name }}
            </p>
          </div>

          <!-- Column Mapping -->
          <div v-if="showMapping" class="mt-6">
            <h4 class="text-sm font-medium text-gray-900 mb-4">Map CSV Columns to Database Fields</h4>
            <div class="grid grid-cols-2 gap-4">
              <div v-for="field in requiredFields" :key="field.dbField" class="space-y-2">
                <label :class="['block text-sm font-medium', field.required ? 'text-gray-900' : 'text-gray-500']">
                  {{ field.label }}
                  <span v-if="field.required" class="text-red-500">*</span>
                </label>
                <select
                  v-model="columnMapping[field.dbField]"
                  :class="[
                    'mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 sm:text-sm',
                    field.required && !columnMapping[field.dbField] ? 'border-red-300' : ''
                  ]"
                >
                  <option value="">Select CSV column</option>
                  <option
                    v-for="header in csvHeaders"
                    :key="header"
                    :value="header"
                  >
                    {{ header }}
                  </option>
                </select>
              </div>
            </div>

            <!-- CSV Preview -->
            <div class="mt-6">
              <h4 class="text-sm font-medium text-gray-900 mb-2">CSV Preview</h4>
              <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                  <thead class="bg-gray-50">
                    <tr>
                      <th
                        v-for="header in csvHeaders"
                        :key="header"
                        class="px-3 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                      >
                        {{ header }}
                      </th>
                    </tr>
                  </thead>
                  <tbody class="bg-white divide-y divide-gray-200">
                    <tr v-for="(row, index) in csvPreview" :key="index">
                      <td
                        v-for="header in csvHeaders"
                        :key="header"
                        class="px-3 py-2 text-sm text-gray-500"
                      >
                        {{ row[header] }}
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <!-- Error Message -->
          <div v-if="error" class="p-3 text-sm text-red-700 bg-red-100 rounded-lg">
            {{ error }}
          </div>

          <!-- Success Message -->
          <div v-if="success" class="p-3 text-sm text-green-700 bg-green-100 rounded-lg">
            {{ success }}
          </div>

          <!-- Footer -->
          <div class="flex justify-end space-x-3 pt-4 border-t border-gray-200">
            <button
              type="button"
              @click="emit('close')"
              class="btn btn-secondary"
              :disabled="isUploading"
            >
              Cancel
            </button>
            <button
              type="button"
              @click="handleSubmit"
              class="btn btn-primary"
              :disabled="isUploading || !file || (showMapping && !isMappingValid)"
            >
              <span v-if="isUploading">Uploading...</span>
              <span v-else>Import Contacts</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template> 