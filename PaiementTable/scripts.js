document.addEventListener("DOMContentLoaded", function() {
    const paymentData = [
        {
            date: '25-05-2024',
            driver: 'Chai Ren',
            car: 'Peageout 301 2013',
            oldCredit: 400,
            debit: 250,
            versment: 300,
            paymentDeadline: '25-08-2024'
        },
        {
            date: '22-03-2024',
            driver: 'Bouaza Ycef',
            car: 'Peageout C3 2015',
            oldCredit: 0,
            debit: 150,
            versment: 0,
            paymentDeadline: '22-06-2024'
        },
        {
            date: '11-02-2024',
            driver: 'Abo Mamed',
            car: 'VW passat 2015',
            oldCredit: 200,
            debit: 350,
            versment: 550,
            paymentDeadline: '11-05-2024'
        },
        {
            date: '06-06-2024',
            driver: 'Al Bn',
            car: 'Peageout Partner',
            oldCredit: 3500,
            debit: 200,
            versment: 2000,
            paymentDeadline: '06-09-2024'
        },
        {
            date: '17-03-2024',
            driver: 'Brim Khil',
            car: 'Hyundai santafe 2014',
            oldCredit: 800,
            debit: 400,
            versment: 1000,
            paymentDeadline: '17-06-2024'
        }
    ];

    const tableBody = document.querySelector("#paymentTable tbody");
    const searchInput = document.getElementById("searchInput");

    const detailDate = document.getElementById("detailDate");
    const detailDriver = document.getElementById("detailDriver");
    const detailCar = document.getElementById("detailCar");
    const detailOldCredit = document.getElementById("detailOldCredit");
    const detailDebit = document.getElementById("detailDebit");
    const detailVersment = document.getElementById("detailVersment");
    const detailNewCredit = document.getElementById("detailNewCredit");
    const detailPaymentDeadline = document.getElementById("detailPaymentDeadline");
    const paymentDetails = document.getElementById("paymentDetails");
    const closeDetailsButton = document.getElementById("closeDetails");

    function renderTable(data) {
        tableBody.innerHTML = '';
        data.forEach(payment => {
            const newCredit = (payment.oldCredit + payment.debit) - payment.versment;
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${payment.date}</td>
                <td>${payment.driver}</td>
                <td>${payment.car}</td>
                <td>${payment.oldCredit.toFixed(2)}</td>
                <td>${payment.debit.toFixed(2)}</td>
                <td>${payment.versment.toFixed(2)}</td>
                <td>${newCredit.toFixed(2)}</td>
                <td>${payment.paymentDeadline}</td>
            `;
            row.addEventListener("click", function() {
                detailDate.textContent = payment.date;
                detailDriver.textContent = payment.driver;
                detailCar.textContent = payment.car;
                detailOldCredit.textContent = payment.oldCredit.toFixed(2);
                detailDebit.textContent = payment.debit.toFixed(2);
                detailVersment.textContent = payment.versment.toFixed(2);
                detailNewCredit.textContent = newCredit.toFixed(2);
                detailPaymentDeadline.textContent = payment.paymentDeadline;
                paymentDetails.classList.remove("hidden");
            });
            tableBody.appendChild(row);
        });
    }

    renderTable(paymentData);

    searchInput.addEventListener("input", function() {
        const searchValue = searchInput.value.toLowerCase();
        const filteredData = paymentData.filter(payment => 
            payment.driver.toLowerCase().includes(searchValue)
        );
        renderTable(filteredData);
    });

    closeDetailsButton.addEventListener("click", function() {
        paymentDetails.classList.add("hidden");
    });
});
