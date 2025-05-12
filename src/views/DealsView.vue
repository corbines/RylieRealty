<script setup>
import { ref } from 'vue'
import { PlusIcon } from '@heroicons/vue/24/outline'
import AddDealModal from '../components/modals/AddDealModal.vue'

// Mock data for deals
const deals = ref([
  {
    id: 1,
    name: 'Website Redesign',
    company: 'Acme Corp',
    value: 25000,
    expectedCloseDate: '2024-04-15',
    status: 'New'
  },
  {
    id: 2,
    name: 'Software License',
    company: 'TechStart Inc',
    value: 15000,
    expectedCloseDate: '2024-04-01',
    status: 'Proposal'
  },
  {
    id: 3,
    name: 'Cloud Migration',
    company: 'Global Solutions',
    value: 50000,
    expectedCloseDate: '2024-05-01',
    status: 'Negotiation'
  },
  {
    id: 4,
    name: 'Security Audit',
    company: 'Innovate Co',
    value: 20000,
    expectedCloseDate: '2024-03-20',
    status: 'Closed Won'
  },
  {
    id: 5,
    name: 'Training Program',
    company: 'Future Tech',
    value: 10000,
    expectedCloseDate: '2024-03-15',
    status: 'Closed Lost'
  },
  {
    id: 6,
    name: 'Mobile App Development',
    company: 'StartupX',
    value: 75000,
    expectedCloseDate: '2024-06-01',
    status: 'New'
  },
  {
    id: 7,
    name: 'Data Analytics Platform',
    company: 'DataFlow Inc',
    value: 45000,
    expectedCloseDate: '2024-05-15',
    status: 'Proposal'
  },
  {
    id: 8,
    name: 'CRM Integration',
    company: 'SalesForce Pro',
    value: 35000,
    expectedCloseDate: '2024-04-30',
    status: 'Negotiation'
  },
  {
    id: 9,
    name: 'AI Chatbot Implementation',
    company: 'SmartBot Solutions',
    value: 60000,
    expectedCloseDate: '2024-03-25',
    status: 'Closed Won'
  },
  {
    id: 10,
    name: 'Legacy System Upgrade',
    company: 'OldTech Corp',
    value: 120000,
    expectedCloseDate: '2024-03-10',
    status: 'Closed Lost'
  },
  {
    id: 11,
    name: 'E-commerce Platform',
    company: 'RetailPlus',
    value: 85000,
    expectedCloseDate: '2024-06-15',
    status: 'New'
  },
  {
    id: 12,
    name: 'IoT Device Management',
    company: 'SmartThings Co',
    value: 95000,
    expectedCloseDate: '2024-05-20',
    status: 'Proposal'
  },
  {
    id: 13,
    name: 'Blockchain Integration',
    company: 'CryptoChain',
    value: 150000,
    expectedCloseDate: '2024-05-10',
    status: 'Negotiation'
  },
  {
    id: 14,
    name: 'Video Streaming Service',
    company: 'StreamTech',
    value: 200000,
    expectedCloseDate: '2024-03-28',
    status: 'Closed Won'
  },
  {
    id: 15,
    name: 'AR/VR Development',
    company: 'VirtualWorld',
    value: 180000,
    expectedCloseDate: '2024-03-05',
    status: 'Closed Lost'
  },
  {
    id: 16,
    name: 'Cybersecurity Suite',
    company: 'SecureNet',
    value: 65000,
    expectedCloseDate: '2024-06-30',
    status: 'New'
  },
  {
    id: 17,
    name: 'Payment Gateway Integration',
    company: 'PayTech Solutions',
    value: 45000,
    expectedCloseDate: '2024-05-25',
    status: 'Proposal'
  },
  {
    id: 18,
    name: 'Machine Learning Model',
    company: 'AI Innovations',
    value: 120000,
    expectedCloseDate: '2024-05-15',
    status: 'Negotiation'
  },
  {
    id: 19,
    name: 'Cloud Storage Solution',
    company: 'StoragePro',
    value: 85000,
    expectedCloseDate: '2024-03-22',
    status: 'Closed Won'
  },
  {
    id: 20,
    name: 'Digital Marketing Platform',
    company: 'MarketGrow',
    value: 55000,
    expectedCloseDate: '2024-03-12',
    status: 'Closed Lost'
  }
])

const columns = [
  { id: 'New', title: 'New', color: 'bg-gray-100' },
  { id: 'Proposal', title: 'Proposal', color: 'bg-blue-100' },
  { id: 'Negotiation', title: 'Negotiation', color: 'bg-yellow-100' },
  { id: 'Closed Won', title: 'Closed Won', color: 'bg-green-100' },
  { id: 'Closed Lost', title: 'Closed Lost', color: 'bg-red-100' }
]

const getDealsByStatus = (status) => {
  return deals.value.filter(deal => deal.status === status)
}

const formatCurrency = (value) => {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0
  }).format(value)
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  })
}

const showAddDealModal = ref(false)

const handleAddDeal = (dealData) => {
  // Add the new deal to the list
  deals.value.push({
    id: deals.value.length + 1,
    name: dealData.name,
    company: dealData.company,
    value: dealData.value,
    expectedCloseDate: dealData.expectedCloseDate,
    status: dealData.stage === 'closed_won' ? 'Closed Won' : 
            dealData.stage === 'closed_lost' ? 'Closed Lost' :
            dealData.stage === 'negotiation' ? 'Negotiation' :
            dealData.stage === 'proposal' ? 'Proposal' : 'New'
  })
}

const draggedDeal = ref(null)
const dragOverStatus = ref(null)

const handleDragStart = (deal, event) => {
  draggedDeal.value = deal
  // Add a semi-transparent effect to the dragged item
  event.target.classList.add('opacity-50')
  // Set the drag image to be the card itself
  event.dataTransfer.effectAllowed = 'move'
  event.dataTransfer.setData('text/plain', deal.id)
}

const handleDragEnd = (event) => {
  draggedDeal.value = null
  dragOverStatus.value = null
  // Remove the semi-transparent effect
  event.target.classList.remove('opacity-50')
}

const handleDragOver = (status, event) => {
  event.preventDefault()
  dragOverStatus.value = status
}

const handleDragLeave = (event) => {
  dragOverStatus.value = null
}

const handleDrop = (status, event) => {
  event.preventDefault()
  if (draggedDeal.value && status !== draggedDeal.value.status) {
    // Update the deal's status
    const dealIndex = deals.value.findIndex(d => d.id === draggedDeal.value.id)
    if (dealIndex !== -1) {
      deals.value[dealIndex] = {
        ...deals.value[dealIndex],
        status: status
      }
    }
  }
  dragOverStatus.value = null
}
</script>

<template>
  <div class="space-y-6">
    <!-- Page Header -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-2xl font-semibold text-gray-900">Deals & Opportunities</h1>
        <p class="mt-1 text-sm text-gray-500">
          Track and manage your sales pipeline.
        </p>
      </div>
      
      <button 
        @click="showAddDealModal = true"
        class="btn btn-primary flex items-center"
      >
        <PlusIcon class="w-5 h-5 mr-2" />
        Add Deal
      </button>
    </div>

    <!-- Kanban Board -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
      <div
        v-for="column in columns"
        :key="column.id"
        class="space-y-4"
        @dragover="handleDragOver(column.id, $event)"
        @dragleave="handleDragLeave"
        @drop="handleDrop(column.id, $event)"
      >
        <!-- Column Header -->
        <div
          :class="[
            'px-4 py-2 rounded-lg font-medium text-sm',
            column.color,
            column.id === 'Closed Won' || column.id === 'Closed Lost'
              ? 'text-gray-900'
              : 'text-gray-700',
            dragOverStatus === column.id ? 'ring-2 ring-primary-500 ring-inset' : ''
          ]"
        >
          {{ column.title }}
          <span class="ml-2 text-gray-500">
            ({{ getDealsByStatus(column.id).length }})
          </span>
        </div>

        <!-- Deal Cards -->
        <div 
          class="space-y-4 min-h-[100px]"
          :class="{ 'bg-primary-50/50 rounded-lg transition-colors duration-200': dragOverStatus === column.id }"
        >
          <div
            v-for="deal in getDealsByStatus(column.id)"
            :key="deal.id"
            class="card p-4 cursor-move hover:shadow-md transition-shadow duration-200"
            draggable="true"
            @dragstart="handleDragStart(deal, $event)"
            @dragend="handleDragEnd($event)"
          >
            <h3 class="font-medium text-gray-900">{{ deal.name }}</h3>
            <p class="text-sm text-gray-500 mt-1">{{ deal.company }}</p>
            
            <div class="mt-4 space-y-2">
              <div class="flex justify-between text-sm">
                <span class="text-gray-500">Value</span>
                <span class="font-medium text-gray-900">
                  {{ formatCurrency(deal.value) }}
                </span>
              </div>
              
              <div class="flex justify-between text-sm">
                <span class="text-gray-500">Expected Close</span>
                <span class="font-medium text-gray-900">
                  {{ formatDate(deal.expectedCloseDate) }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Add Deal Modal -->
    <AddDealModal
      :is-open="showAddDealModal"
      @close="showAddDealModal = false"
      @submit="handleAddDeal"
    />
  </div>
</template>

<style scoped>
.card {
  user-select: none;
}

.card:active {
  cursor: grabbing;
}
</style> 