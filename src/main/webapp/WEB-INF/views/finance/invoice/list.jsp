<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice List</title>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
</head>
<body>
<h2>Invoice List</h2>

<table border="1" width="100%">
    <thead>
    <tr>
        <th>Invoice ID</th>
        <th>Invoice Date</th>
        <th>Total Amount</th>
        <th>Status</th>
        <th>Warehouse ID</th>
        <th>User ID</th>
    </tr>
    </thead>
    <tbody id="invoiceTableBody">
    <tr>
        <td colspan="6" align="center">Loading...</td>
    </tr>
    </tbody>
</table>

<script>
    async function loadInvoices() {
        try {
            const response = await axios.get('/finance/invoice'); // APIController 호출
            const list = response.data;
            const tbody = document.getElementById('invoiceTableBody');
            tbody.innerHTML = '';

            if (!list || list.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" align="center">No data</td></tr>';
                return;
            }

            list.forEach(inv => {
                const row = `
                        <tr>
                            <td>${inv.invoiceId}</td>
                            <td>${inv.invoiceDt}</td>
                            <td>${inv.totalAmt}</td>
                            <td>${inv.invoiceStatus}</td>
                            <td>${inv.whId}</td>
                            <td>${inv.userId}</td>
                        </tr>`;
                tbody.insertAdjacentHTML('beforeend', row);
            });
        } catch (error) {
            console.error(error);
            document.getElementById('invoiceTableBody').innerHTML =
                '<tr><td colspan="6" align="center">Error loading data</td></tr>';
        }
    }

    loadInvoices();
</script>
</body>
</html>