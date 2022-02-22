// Entry point for the build script in your package.json
import Rails from '@rails/ujs'

import halfmoon from 'halfmoon'

import 'controllers'
import useAppToast from 'app/use_app_toast'

const onPageLoad = () => {
  halfmoon.onDOMContentLoaded();
  useAppToast()
  document.getElementById('sidebar-overlay').addEventListener('click', () => halfmoon.toggleSidebar())
  document.getElementById('sidebar-toggle').addEventListener('click', () => halfmoon.toggleSidebar())
}

document.addEventListener('DOMContentLoaded', onPageLoad)
Rails.start()
