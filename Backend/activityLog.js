const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
require('mongodb');
const moment = require('moment');
const jwt = require('jsonwebtoken');
const fs = require('fs');

const JWT_SECRET = process.env.secretkey;

// Middleware to log user activities
const logActivity = (activity) => {
  const logMessage = `${moment().format('YYYY-MM-DD HH:mm:ss')} - ${activity}\n`;
  fs.appendFile('user_activities.log', logMessage, (err) => {
    if (err) {
      console.error('Error logging activity:', err);
    }
  });
};

// Middleware to verify JWT token
const verifyToken = (req, res, next) => {
  const tokenHeader = req.headers['authorization'];

  if (!tokenHeader) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  const token = tokenHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  jwt.verify(token, JWT_SECRET, (err, decoded) => {
    if (err) {
      if (err.name === 'TokenExpiredError') {
        return res.status(403).json({ message: 'Token expired' });
      } else {
        return res.status(403).json({ message: 'Invalid token' });
      }
    }
    req.user = decoded;
    next();
  });
};

const app = express();
const PORT = process.env.PORT;

app.use(cors());
app.use(bodyParser.json({ limit: '10mb' }));

mongoose.connect(process.env.MongoDBURL, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const passengerSchema = new mongoose.Schema({
  familyName: String,
  firstName: String,
  NIS: String,
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true,
  },
  password: {
    type: String,
    required: true,
    minlength: 6,
  },
  phoneNumber: String,
  gender: String,
  yearOfBirth: String,
  profileImage: String,
});

const carDataSchema = new mongoose.Schema({
  carName: String,
  carMarque: String,
  year: String,
  immatric: String,
  carteGrise: String,
  carColor: String,
  assurence: String,
  controlTechnique: String,
  vignette: String,
});

const driverSchema = new mongoose.Schema({
  familyName: String,
  firstName: String,
  NIS: String,
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true,
  },
  password: {
    type: String,
    required: true,
    minlength: 6,
  },
  phoneNumber: String,
  gender: String,
  yearOfBirth: String,
  profileImage: String,
  carData: {
    carName: String,
    carMarque: String,
    year: String,
    immatric: String,
    carColor: String,
  },
});

const rideSchema = new mongoose.Schema({
  driver: {
    familyName: String,
    firstName: String,
    email: String,
    phoneNumber: String,
    profileImage: String,
    yearOfBirth: String,
    carData: {
      carName: String,
      carMarque: String,
      year: String,
      immatric: String,
      carColor: String,
    },
  },
  depart: String,
  location: String,
  date: String,
  seats: Number,
  price: Number,
  time: String,
  meetPlace: String,
});

const depannageSchema = new mongoose.Schema({
  driver: {
    familyName: String,
    firstName: String,
    email: String,
    phoneNumber: String,
    profileImage: String,
    yearOfBirth: String,
    carData: {
      carName: String,
      carMarque: String,
      year: String,
      immatric: String,
      carColor: String,
    },
  },
  location: String,
});

passengerSchema.pre('save', async function (next) {
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

driverSchema.pre('save', async function (next) {
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

const Passenger = mongoose.model('Passenger', passengerSchema);
const Driver = mongoose.model('Driver', driverSchema);
const Ride = mongoose.model('Ride', rideSchema);
const Depannage = mongoose.model('Depannage', depannageSchema);

// Helper function to log activities
const logUserActivity = (req, action) => {
  const email = req.user?.email || req.body.email;
  logActivity(`${email} - ${action}`);
};

// Endpoint to fetch activity logs
app.get('/api/userActivities', (req, res) => {
  fs.readFile('user_activities.log', 'utf8', (err, data) => {
    if (err) {
      return res.status(500).json({ message: 'Internal Server Error' });
    }
    const logs = data.split('\n').filter(log => log).map(log => {
      const [timestamp, activity] = log.split(' - ');
      return { timestamp, activity };
    });
    res.status(200).json(logs);
  });
});

// PASSENGER SIGN UP
app.post('/api/addPassenger', async (req, res) => {
  try {
    const base64Image = req.body.profileImage;
    const imageBuffer = Buffer.from(base64Image, 'base64');
    const imagePath = 'lib/profilePics';

    if (!fs.existsSync(imagePath)) {
      fs.mkdirSync(imagePath, { recursive: true });
    }

    const imageName = `profile_${Date.now()}.jpg`;
    const imageFullPath = `${imagePath}/${imageName}`;

    fs.writeFileSync(imageFullPath, imageBuffer);

    req.body.profileImage = imageFullPath;

    const newPassenger = new Passenger(req.body);
    await newPassenger.save();

    logActivity(`New passenger added: ${req.body.email}`);
    res.status(200).json({ message: 'Passenger added successfully!' });
  } catch (error) {
    if (error.code === 11000) {
      res.status(400).json({ message: 'Email already exists.' });
    } else {
      res.status(500).json({ message: 'Internal Server Error' });
    }
  }
});

// DRIVER SIGN UP
app.post('/api/addDriver', async (req, res) => {
  try {
    const base64Image = req.body.profileImage;
    const imageBuffer = Buffer.from(base64Image, 'base64');
    const imagePath = 'lib/profilePics';

    if (!fs.existsSync(imagePath)) {
      fs.mkdirSync(imagePath, { recursive: true });
    }

    const imageName = `profile_${Date.now()}.jpg`;
    const imageFullPath = `${imagePath}/${imageName}`;

    fs.writeFileSync(imageFullPath, imageBuffer);

    req.body.profileImage = imageFullPath;

    const newDriver = new Driver(req.body);
    await newDriver.save();

    logActivity(`New driver added: ${req.body.email}`);
    res.status(200).json({ message: 'Driver added successfully!' });
  } catch (error) {
    if (error.code === 11000) {
      res.status(400).json({ message: 'Email already exists.' });
    } else {
      res.status(500).json({ message: 'Internal Server Error' });
    }
  }
});

// LOGIN
app.post('/api/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await Passenger.findOne({ email }) || await Driver.findOne({ email });

    if (user && (await bcrypt.compare(password, user.password))) {
      const token = jwt.sign({ email: user.email }, JWT_SECRET, { expiresIn: '1h' });
      res.status(200).json({ message: 'Login successful!', token });
      logActivity(`User logged in: ${email}`);
    } else {
      res.status(401).json({ message: 'Invalid email or password.' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

// ADD RIDE
app.post('/api/addRide', verifyToken, async (req, res) => {
  try {
    const { email } = req.user;
    const driver = await Driver.findOne({ email });

    if (!driver) {
      return res.status(404).json({ message: 'Driver not found.' });
    }

    const rideData = {
      ...req.body,
      driver: {
        familyName: driver.familyName,
        firstName: driver.firstName,
        email: driver.email,
        phoneNumber: driver.phoneNumber,
        profileImage: driver.profileImage,
        yearOfBirth: driver.yearOfBirth,
        carData: driver.carData,
      },
    };

    const newRide = new Ride(rideData);
    await newRide.save();

    logActivity(`added ride: ${email}`);
    res.status(200).json({ message: 'Ride added successfully!' });
  } catch (error) {
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

/////////////////// SEARCH RIDE /////////////////
app.post('/api/searchRides', async (req, res) => {
  try {
    const { depart, location, seats, date, include_greater_seats } = req.body;
    console.log('Search Criteria:', { depart, location, seats, date });

    let query = {
      depart,
      location,
      date,
    };

    if (include_greater_seats) {
      query.seats = { $gte: seats };
    } else {
      query.seats = seats;
    }

    const rides = await Ride.find(query);

    console.log('Found Rides:', rides);
    res.status(200).json({ rides });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

/////////////////// RANDOM RIDES /////////////////////
app.get('/api/randomRides', async (req, res) => {
  try {
    const randomRides = await Ride.aggregate([{ $sample: { size: 5 } }]);
    res.status(200).json({ randomRides });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

/////////////////// PROFILE PAGE /////////////////////
//        Profile endpoint to display user's data
app.get('/api/profile', verifyToken, async (req, res) => {
  try {
    const { email } = req.user;
    const passenger = await Passenger.findOne({ email });
    const driver = await Driver.findOne({ email });

    if (!passenger && !driver) {
      console.error('User not found:', email); // Log user not found error
      return res.status(404).json({ message: 'User not found.' });
    }

    let userData = {
      familyName: '',
      firstName: '',
      NIS: '',
      email: '',
      phoneNumber: '',
      gender: '',
      yearOfBirth: '',
      profileImage: '',
    };

    if (passenger) {
      userData = {
        ...userData,
        familyName: passenger.familyName,
        firstName: passenger.firstName,
        NIS: passenger.NIS,
        email: passenger.email,
        phoneNumber: passenger.phoneNumber,
        gender: passenger.gender,
        yearOfBirth: passenger.yearOfBirth,
        profileImage: passenger.profileImage,
      };
    }

    if (driver) {
      userData = {
        ...userData,
        familyName: driver.familyName,
        firstName: driver.firstName,
        NIS: driver.NIS,
        email: driver.email,
        phoneNumber: driver.phoneNumber,
        gender: driver.gender,
        yearOfBirth: driver.yearOfBirth,
        profileImage: driver.profileImage,
        carName: driver.carData.carName,
        carMarque: driver.carData.carMarque,
        year: driver.carData.year,
      };
    }

    logActivity(`viewd his profile: ${email}`);
    res.status(200).json(userData);
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      console.error('Token Expired:', error.message); // Log token expired error
      return res.status(401).json({ message: 'Token expired.' });
    } else if (error.name === 'JsonWebTokenError') {
      console.error('Invalid Token:', error.message); // Log invalid token error
      return res.status(401).json({ message: 'Invalid token.' });
    } else {
      console.error('Internal Server Error:', error); // Log other internal server errors
      return res.status(500).json({ message: 'Internal Server Error' });
    }
  }
});


// GET RIDES
app.get('/api/rides', async (req, res) => {
  try {
    const rides = await Ride.find();
    res.status(200).json(rides);
  } catch (error) {
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

// ADD DEPANNAGE
app.post('/api/addDepannage', verifyToken, async (req, res) => {
  try {
    const { email } = req.user;
    const driver = await Driver.findOne({ email });

    if (!driver) {
      return res.status(404).json({ message: 'Driver not found.' });
    }

    const depannageData = {
      ...req.body,
      driver: {
        familyName: driver.familyName,
        firstName: driver.firstName,
        email: driver.email,
        phoneNumber: driver.phoneNumber,
        profileImage: driver.profileImage,
        yearOfBirth: driver.yearOfBirth,
        carData: driver.carData,
      },
    };

    const newDepannage = new Depannage(depannageData);
    await newDepannage.save();

    logActivity(`added depannage: ${email}`);
    res.status(200).json({ message: 'Depannage added successfully!' });
  } catch (error) {
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

// GET DEPANNAGE
app.get('/api/searchDepannage', async (req, res) => {
  try {
    const depannages = await Depannage.find();
    res.status(200).json(depannages);
  } catch (error) {
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
