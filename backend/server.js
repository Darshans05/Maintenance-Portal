const express = require('express');
const axios = require('axios');
const cors = require('cors');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const SAP_BASE = process.env.SAP_BASE;

// Read auth directly from env. Will be updated manually by user if needed.
const getAuthHeader = () => {
  return 'Basic ' + Buffer.from(`${process.env.SAP_USER}:${process.env.SAP_PASS}`).toString('base64');
};

/* ROOT */
app.get('/', (req, res) => {
  res.send('Maintenance Portal Backend Running');
});

/* MOCK LOGIN API */
// In this setup, auth is handled via the backend's .env file, so the flutter login 
// just needs a success response to proceed to the dashboard.
app.post('/login', async (req, res) => {
  try {
    const { employeeId, password } = req.body;
    // Verify against a known working endpoint instead of $metadata which might require sap-client
    await axios.get(`${SAP_BASE}/Z_MAINTNOTIY_DSSet?$top=1&$format=json&sap-client=100`, {
      headers: { 
        Authorization: getAuthHeader(),
        Accept: 'application/json' 
      }
    });

    res.send({ d: { EMP_ID: employeeId, NAME: "Employee" } });
  } catch (error) {
    console.error('LOGIN ERROR:', error.response?.data || error.message);
    res.status(401).send({ message: 'Login failed - check SAP credentials' });
  }
});

/* NOTIFICATIONS API */
app.get('/notifications', async (req, res) => {
  try {
    const { qmart, priok } = req.query;
    // Base URL for notifications with required format and client
    let url = `${SAP_BASE}/Z_MAINTNOTIY_DSSet?$format=json&sap-client=100`;

    // Basic filtering if needed later, but the Flutter app currently fetches all and filters locally.
    
    console.log("Fetching Notifications from:", url);
    const response = await axios.get(url, { 
      headers: { 
        Authorization: getAuthHeader(),
        Accept: 'application/json' 
      } 
    });
    
    res.send(response.data);
  } catch (error) {
    console.error('NOTIFICATION ERROR:', error.response?.data || error.message);
    res.status(500).send({ message: 'Notification fetch failed' });
  }
});

/* SINGLE NOTIFICATION */
app.get('/notification/:id', async (req, res) => {
  try {
    const id = req.params.id;
    const url = `${SAP_BASE}/Z_MAINTNOTIY_DSSet('${id}')?$format=json&sap-client=100`;
    const response = await axios.get(url, { 
      headers: { Authorization: getAuthHeader(), Accept: 'application/json' } 
    });
    res.send(response.data);
  } catch (error) {
    console.error('SINGLE NOTIFY ERROR:', error.response?.data || error.message);
    res.status(500).send({ message: 'Notification detail failed' });
  }
});

/* PLANTS API */
app.get('/plants', async (req, res) => {
  try {
    const url = `${SAP_BASE}/Z_MAINTPLANT_DSSet?$format=json&sap-client=100`;
    console.log('Fetching Plants from:', url);
    const response = await axios.get(url, { 
      headers: { Authorization: getAuthHeader(), Accept: 'application/json' } 
    });
    res.send(response.data);
  } catch (error) {
    console.error('PLANT ERROR:', error.response?.data || error.message);
    res.status(500).send({ message: 'Plant fetch failed' });
  }
});

/* WORK ORDERS API */
app.get('/workorders', async (req, res) => {
  try {
    const url = `${SAP_BASE}/Z_MAINTWO_DSSet?$format=json&sap-client=100`;
    console.log("Fetching Work Orders from:", url);
    const response = await axios.get(url, { 
      headers: { Authorization: getAuthHeader(), Accept: 'application/json' } 
    });
    res.send(response.data);
  } catch (error) {
    console.error('WORKORDER ERROR:', error.response?.data || error.message);
    res.status(500).send({ message: 'Work order fetch failed' });
  }
});

/* SINGLE WORK ORDER */
app.get('/workorder/:id', async (req, res) => {
  try {
    const id = req.params.id;
    const url = `${SAP_BASE}/Z_MAINTWO_DSSet('${id}')?$format=json&sap-client=100`;
    const response = await axios.get(url, { 
      headers: { Authorization: getAuthHeader(), Accept: 'application/json' } 
    });
    res.send(response.data);
  } catch (error) {
    console.error('SINGLE WORKORDER ERROR:', error.response?.data || error.message);
    res.status(500).send({ message: 'Work order detail failed' });
  }
});

/* START SERVER */
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
