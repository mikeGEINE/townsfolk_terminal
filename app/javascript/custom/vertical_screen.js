function adjustContainerSize() {
  const container = document.getElementById('appContainer');
  const viewportHeight = window.innerHeight;
  const viewportWidth = window.innerWidth;
  const aspectRatioWidth = (9 / 16) * viewportHeight;
  const aspectRatioHeight = (16 / 9) * viewportWidth;

  if (viewportHeight < aspectRatioHeight) {
      container.style.width = `${aspectRatioWidth}px`;
      container.style.height = `${viewportHeight}px`;
  } else {
      container.style.width = `${viewportWidth}px`;
      container.style.height = `${aspectRatioHeight}px`;
  }

  const root = document.documentElement;
  root.style.fontSize = `${container.offsetHeight * 0.03}px`;
}

adjustContainerSize(); // Call initially

window.addEventListener('resize', adjustContainerSize); // Call on window resize

export { adjustContainerSize };
