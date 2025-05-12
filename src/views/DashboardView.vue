<script setup>
import { ref } from 'vue'
import {
  UserGroupIcon,
  UserPlusIcon,
  CurrencyDollarIcon,
  ChartBarIcon
} from '@heroicons/vue/24/outline'
import DashboardCard from '../components/dashboard/DashboardCard.vue'
import { Bar } from 'vue-chartjs'
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
} from 'chart.js'

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
)

// Mock data for metrics
const metrics = [
  {
    title: 'Total Contacts',
    value: '2,543',
    change: 12,
    icon: UserGroupIcon
  },
  {
    title: 'New Leads',
    value: '245',
    change: 8,
    icon: UserPlusIcon
  },
  {
    title: 'Deals Won',
    value: '$45,231',
    change: -3,
    icon: CurrencyDollarIcon
  },
  {
    title: 'Revenue',
    value: '$124,563',
    change: 15,
    icon: ChartBarIcon
  }
]

// Mock data for sales chart
const chartData = {
  labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
  datasets: [
    {
      label: 'Sales',
      data: [30, 40, 35, 50, 49, 60],
      backgroundColor: '#ec4899',
      borderRadius: 4
    }
  ]
}

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: false
    }
  },
  scales: {
    y: {
      beginAtZero: true,
      grid: {
        display: true,
        drawBorder: false
      }
    },
    x: {
      grid: {
        display: false
      }
    }
  }
}

// Mock data for recent activity
const recentActivity = ref([
  {
    id: 1,
    type: 'Contact Added',
    contact: 'Sarah Johnson',
    date: '2024-03-15',
    assignedTo: 'John Doe'
  },
  {
    id: 2,
    type: 'Deal Updated',
    contact: 'Mike Smith',
    date: '2024-03-14',
    assignedTo: 'Jane Smith'
  },
  {
    id: 3,
    type: 'Task Completed',
    contact: 'David Wilson',
    date: '2024-03-14',
    assignedTo: 'John Doe'
  },
  {
    id: 4,
    type: 'Deal Won',
    contact: 'Emily Brown',
    date: '2024-03-13',
    assignedTo: 'Jane Smith'
  }
])
</script>

<template>
  <div class="space-y-6">
    <!-- Page Title -->
    <div>
      <h1 class="text-2xl font-semibold text-gray-900">Dashboard Overview</h1>
      <p class="mt-1 text-sm text-gray-500">
        Welcome back! Here's what's happening with your CRM today.
      </p>
    </div>

    <!-- Metrics Grid -->
    <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4">
      <DashboardCard
        v-for="metric in metrics"
        :key="metric.title"
        v-bind="metric"
      />
    </div>

    <!-- Charts Section -->
    <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
      <!-- Sales Chart -->
      <div class="card p-6">
        <h2 class="text-lg font-medium text-gray-900">Sales Performance</h2>
        <div class="mt-4 h-80">
          <Bar :data="chartData" :options="chartOptions" />
        </div>
      </div>

      <!-- Lead Sources Chart -->
      <div class="card p-6">
        <h2 class="text-lg font-medium text-gray-900">Lead Sources</h2>
        <div class="mt-4 h-80 flex items-center justify-center text-gray-500">
          [Lead Sources Chart Placeholder]
        </div>
      </div>
    </div>

    <!-- Recent Activity -->
    <div class="card">
      <div class="px-6 py-4 border-b border-gray-200">
        <h2 class="text-lg font-medium text-gray-900">Recent Activity</h2>
      </div>
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th
                v-for="header in ['Activity Type', 'Contact', 'Date', 'Assigned To']"
                :key="header"
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                {{ header }}
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            <tr
              v-for="activity in recentActivity"
              :key="activity.id"
              class="hover:bg-gray-50"
            >
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ activity.type }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                {{ activity.contact }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ activity.date }}
              </td>
              <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {{ activity.assignedTo }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template> 