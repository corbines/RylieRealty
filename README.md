# Vue CRM Dashboard

A modern, responsive Customer Relationship Management (CRM) dashboard built with Vue 3 and Tailwind CSS.

## Features

- 🎨 Modern, clean UI with Tailwind CSS
- 📱 Fully responsive design
- 🔄 Real-time data updates (mock data for now)
- 📊 Interactive charts and metrics
- 👥 Contact management
- 💼 Deal pipeline with Kanban board
- 🔍 Search and filtering capabilities
- 🎯 Activity tracking

## Tech Stack

- Vue 3 (Composition API)
- Vue Router
- Tailwind CSS
- Chart.js
- Heroicons
- Headless UI

## Project Setup

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

## Project Structure

```
src/
├── components/
│   ├── dashboard/
│   │   └── DashboardCard.vue
│   └── layout/
│       ├── Header.vue
│       └── Sidebar.vue
├── views/
│   ├── DashboardView.vue
│   ├── ContactsView.vue
│   └── DealsView.vue
├── router/
│   └── index.js
├── App.vue
└── main.js
```

## Features in Detail

### Dashboard Overview
- Key metrics display
- Sales performance chart
- Lead source breakdown
- Recent activity feed

### Contacts Management
- Contact list with search and filtering
- Contact status tracking
- Quick actions for contact management

### Deals Pipeline
- Kanban board view
- Deal status tracking
- Value and close date tracking
- Visual pipeline management

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
