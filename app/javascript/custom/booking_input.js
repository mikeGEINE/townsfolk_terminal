function updateBookingId(event) {
  const buttonValue = event.target.textContent;
  var bookingNumber = document.getElementById("booking_id").value;
  bookingNumber += buttonValue;
  document.getElementById("booking_id").value = bookingNumber;
}

const digitButtons = document.querySelectorAll(".btn-digit");

digitButtons.forEach(button => {
  button.addEventListener("click", updateBookingId, false);
});

function removeLastDigit() {
  var bookingNumber = document.getElementById("booking_id").value;
  bookingNumber = bookingNumber.slice(0, -1);
  document.getElementById("booking_id").value = bookingNumber;
}

document.getElementById("removeLastDigit").addEventListener("click", removeLastDigit, false);
