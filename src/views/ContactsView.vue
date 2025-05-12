<script setup>
import { ref, computed, onMounted } from 'vue'
import { PlusIcon, MagnifyingGlassIcon } from '@heroicons/vue/24/outline'
import AddContactModal from '../components/modals/AddContactModal.vue'
import ImportContactsModal from '../components/modals/ImportContactsModal.vue'

const isImportModalOpen = ref(false)
const contacts = ref([])
const isLoading = ref(false)
const error = ref(null)

// Fetch contacts from the API
const fetchContacts = async () => {
  isLoading.value = true
  error.value = null
  
  try {
    const response = await fetch('http://localhost:3001/api/contacts')
    if (!response.ok) {
      throw new Error('Failed to fetch contacts')
    }
    const data = await response.json()
    contacts.value = data
  } catch (err) {
    error.value = err.message
    console.error('Error fetching contacts:', err)
  } finally {
    isLoading.value = false
  }
}

// Handle contact import completion
const handleImportComplete = (importedCount) => {
  // Refresh the contacts list
  fetchContacts()
}

// Fetch contacts on component mount
onMounted(() => {
  fetchContacts()
})

const searchQuery = ref('')
const statusFilter = ref('all')

const filteredContacts = computed(() => {
  return contacts.value.filter(contact => {
    const matchesSearch = 
      contact.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      contact.email.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      contact.company.toLowerCase().includes(searchQuery.value.toLowerCase())
    
    const matchesStatus = statusFilter.value === 'all' || contact.status === statusFilter.value
    
    return matchesSearch && matchesStatus
  })
})

const statusOptions = [
  { value: 'all', label: 'All Statuses' },
  { value: 'Lead', label: 'Lead' },
  { value: 'Prospect', label: 'Prospect' },
  { value: 'Customer', label: 'Customer' }
]

const statusColors = {
  Lead: 'bg-yellow-100 text-yellow-800',
  Prospect: 'bg-blue-100 text-blue-800',
  Customer: 'bg-green-100 text-green-800'
}

const showAddContactModal = ref(false)

const handleAddContact = (contactData) => {
  // Add the new contact to the list
  contacts.value.push({
    id: contacts.value.length + 1,
    name: `${contactData.firstName} ${contactData.lastName}`,
    email: contactData.email,
    phone: contactData.phone,
    company: contactData.company,
    status: 'Lead' // Default status for new contacts
  })
}

// Update handleContactAdded
const handleContactAdded = async (newContact) => {
  try {
    const response = await fetch('http://localhost:3001/api/contacts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(newContact),
    })

    if (!response.ok) {
      throw new Error('Failed to add contact')
    }

    // Refresh the contacts list
    await fetchContacts()
    showAddContactModal.value = false
  } catch (err) {
    error.value = err.message
    console.error('Error adding contact:', err)
  }
}

// Update deleteContact
const deleteContact = async (id) => {
  if (!confirm('Are you sure you want to delete this contact?')) {
    return
  }

  try {
    const response = await fetch(`http://localhost:3001/api/contacts/${id}`, {
      method: 'DELETE',
    })

    if (!response.ok) {
      throw new Error('Failed to delete contact')
    }

    // Refresh the contacts list
    await fetchContacts()
  } catch (err) {
    error.value = err.message
    console.error('Error deleting contact:', err)
  }
}

// Add editContact function
const editContact = (contact) => {
  // TODO: Implement edit functionality
  console.log('Edit contact:', contact)
}
</script>

<template>
  <div class="container mx-auto px-4 py-8">
    <!-- Header -->
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-bold text-gray-900">Contacts</h1>
      <div class="flex space-x-3">
        <button
          @click="isImportModalOpen = true"
          class="btn btn-secondary"
        >
          Import Contacts
        </button>
        <button
          @click="showAddContactModal = true"
          class="btn btn-primary"
        >
          Add Contact
        </button>
      </div>
    </div>

    <!-- Error Message -->
    <div v-if="error" class="mb-4 p-4 bg-red-100 text-red-700 rounded-lg">
      {{ error }}
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="flex justify-center items-center py-8">
      <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
    </div>

    <!-- Contacts Table -->
    <div v-else class="bg-white rounded-lg shadow overflow-hidden">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th
              v-for="header in ['Name', 'Email', 'Phone', 'Company', 'Status']"
              :key="header"
              class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
            >
              {{ header }}
            </th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr
            v-for="contact in filteredContacts"
            :key="contact.id"
            class="hover:bg-gray-50 cursor-pointer"
          >
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="flex items-center">
                <div class="flex-shrink-0 h-10 w-10">
                  <div class="h-10 w-10 rounded-full bg-primary-100 flex items-center justify-center">
                    <span class="text-primary-600 font-medium">
                      {{ contact.name?.[0] }}
                    </span>
                  </div>
                </div>
                <div class="ml-4">
                  <div class="text-sm font-medium text-gray-900">
                    {{ contact.name }}
                  </div>
                  <div class="text-sm text-gray-500">
                    {{ contact.email }}
                  </div>
                </div>
              </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="text-sm text-gray-900">{{ contact.company }}</div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="text-sm text-gray-900">{{ contact.phone }}</div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="text-sm text-gray-900">{{ contact.city }}, {{ contact.state }}</div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="text-sm text-gray-900">{{ contact.subscription_status_email }}</div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
              <button
                @click="editContact(contact)"
                class="text-primary-600 hover:text-primary-900 mr-3"
              >
                Edit
              </button>
              <button
                @click="deleteContact(contact.id)"
                class="text-red-600 hover:text-red-900"
              >
                Delete
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Modals -->
    <AddContactModal
      :is-open="showAddContactModal"
      @close="showAddContactModal = false"
      @contact-added="handleContactAdded"
    />
    
    <ImportContactsModal
      :is-open="isImportModalOpen"
      @close="isImportModalOpen = false"
      @import-complete="handleImportComplete"
    />
  </div>
</template> 