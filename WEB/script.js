document.addEventListener('DOMContentLoaded', () => {
    fetchPassengers();
    fetchDrivers();
    fetchRides();
  });
  
  function fetchPassengers() {
    fetch('http://localhost:5000/api/passengers')
      .then(response => response.json())
      .then(data => {
        const passengerTableBody = document.getElementById('passengerTable').getElementsByTagName('tbody')[0];
        data.forEach(passenger => {
          const row = passengerTableBody.insertRow();
          row.insertCell(0).textContent = passenger.fullName;
          row.insertCell(1).textContent = passenger.email;
          row.insertCell(2).textContent = passenger.phoneNumber;
        });
      })
      .catch(error => console.error('Error fetching passengers:', error));
  }
   
  function fetchDrivers() {
    fetch('http://localhost:5000/api/drivers')
      .then(response => response.json())
      .then(data => {
        const driverTableBody = document.getElementById('driverTable').getElementsByTagName('tbody')[0];
        data.forEach(driver => {
          const row = driverTableBody.insertRow();
          row.insertCell(0).textContent = driver.fullName;
          row.insertCell(1).textContent = driver.email;
          row.insertCell(2).textContent = driver.phoneNumber;
          row.insertCell(3).textContent = `${driver.carData.carName} (${driver.carData.carMarque}, ${driver.carData.year})`;
        });
      })
      .catch(error => console.error('Error fetching drivers:', error));
  }
  
  function fetchRides() {
    fetch('http://localhost:5000/api/rides')
      .then(response => response.json())
      .then(data => {
        const rideTableBody = document.getElementById('rideTable').getElementsByTagName('tbody')[0];
        data.forEach(ride => {
          const row = rideTableBody.insertRow();
          row.insertCell(0).textContent = ride.driver.fullName;
          row.insertCell(1).textContent = ride.depart;
          row.insertCell(2).textContent = ride.location;
          row.insertCell(3).textContent = ride.date;
          row.insertCell(4).textContent = ride.seats;
          row.insertCell(5).textContent = ride.price;
        });
      })
      .catch(error => console.error('Error fetching rides:', error));
  }
  