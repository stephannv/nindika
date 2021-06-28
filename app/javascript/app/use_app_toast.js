export default () => {
  const toastComponent = document.getElementById('app-toast')

  if (toastComponent) {
    halfmoon.toastAlert('app-toast', 5000)
  }
}

