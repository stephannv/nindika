export default () => {
  return document.head.querySelector('meta[name="csrf-token"]').content
}
