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

// Middleware to verify JWT token
const verifyToken = (req, res, next) => {
  const tokenHeader = req.headers['authorization'];

  if (!tokenHeader) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  // Extract the token from the Authorization header
  const token = tokenHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  // Verify the token
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
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(bodyParser.json({ limit: '10mb' }));

mongoose.connect(process.env.MongoDB_URL , {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const passengerSchema = new mongoose.Schema({
  familyName: String,
  firstName: String,
  NIS: String, //Numéro d'Identification Statique
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
  NIS: String, //Numéro d'Identification Statique
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
    yearOfBirth:String,
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
  meetPlace:String,
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
  location: String,  // Location of the driver
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


////////////////// PASSENGER SIGN UP ////////////////////////////////

app.post('/api/addPassenger', async (req, res) => {
  try {
    console.log(req.body);

    const base64Image = req.body.profileImage;
    const imageBuffer = Buffer.from(base64Image, 'base64');

    // Specify the destination directory for storing profile images
    const imagePath = 'lib/profilePics';

    // Check if the directory exists, if not, create it
    if (!fs.existsSync(imagePath)){
      fs.mkdirSync(imagePath, { recursive: true });
    }

    // Generate a unique filename for the image
    const imageName = `profile_${Date.now()}.jpg`;
    const imageFullPath = `${imagePath}/${imageName}`;

    // Write the image buffer to the file
    fs.writeFileSync(imageFullPath, imageBuffer);

    // Update req.body to include the image URL
    req.body.profileImage = imageFullPath;

    // Create a new passenger instance with the updated req.body
    const newPassenger = new Passenger(req.body);
    // Save the new passenger to the database
    await newPassenger.save();

    res.status(200).json({ message: 'Passenger added successfully!' });
  } catch (error) {
    console.error(error);
    if (error.code === 11000) {
      res.status(400).json({ message: 'Email already exists.' });
    } else {
      res.status(500).json({ message: 'Internal Server Error' });
    }
  }
});

////////////////// DRIVER SIGN UP ////////////////////////////////

app.post('/api/addDriver', async (req, res) => {
  try {
    console.log(req.body);

    const base64Image = req.body.profileImage;
    const imageBuffer = Buffer.from(base64Image, 'base64');

    // Specify the destination directory for storing profile images
    const imagePath = 'lib/profilePics';

    // Check if the directory exists, if not, create it
    if (!fs.existsSync(imagePath)){
      fs.mkdirSync(imagePath, { recursive: true });
    }

    // Generate a unique filename for the image
    const imageName = `profile_${Date.now()}.jpg`;
    const imageFullPath = `${imagePath}/${imageName}`;

    // Write the image buffer to the file
    fs.writeFileSync(imageFullPath, imageBuffer);

    // Update req.body to include the image URL
    req.body.profileImage = imageFullPath;

    // Create a new driver instance with the updated req.body
    const newDriver = new Driver(req.body);

    // Save the new driver to the database
    await newDriver.save();

    // Send success response
    res.status(200).json({ message: 'Driver added successfully!' });
  } catch (error) {
    console.error(error);
    if (error.code === 11000) {
      res.status(400).json({ message: 'Email already exists.' });
    } else {
      res.status(500).json({ message: 'Internal Server Error' });
    }
  }
}); 

/////////////////////// LOGIN ////////////////////////////////////////

app.post('/api/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await Passenger.findOne({ email }) || await Driver.findOne({ email });

    if (user && (await bcrypt.compare(password, user.password))) {
      // Generate JWT token
      const token = jwt.sign({ email: user.email }, JWT_SECRET, { expiresIn: '1h' });
      // Store the JWT token in the response
      res.status(200).json({ message: 'Login successful!', token });
      console.log(`TOKEN generated: ${token}`);
    } else {
      res.status(401).json({ message: 'Invalid email or password.' });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on port: ${PORT}`);
});
 

////////////////////// RESET PASSWORD ////////////////////

app.post('/api/resetPassword', async (req, res) => {
  try {
    const { email } = req.body;
    const user = await Passenger.findOne({ email }) || await Driver.findOne({ email });

    if (!user) {
      return res.status(404).json({ message: 'User not found.' });
    }

    // Generate a unique token and save it to the user's document
    const resetToken = generateUniqueToken();
    user.resetPasswordToken = resetToken;
    user.resetPasswordExpires = Date.now() + 3600000; // Token expires in 1 hour

    await user.save();

    // Send an email with the reset token to the user (you need to implement this)

    res.status(200).json({ message: 'Reset token generated successfully.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

function generateUniqueToken() {
  // Implement your logic to generate a unique token (e.g., using crypto library)
  // This is just a placeholder, you should replace it with your actual token generation logic
  return Math.random().toString(36).slice(2);
}

////////////////// ADD RIDE /////////////////////////////

app.post('/api/addRide', verifyToken, async (req, res) => {
  try {
    console.log(req.body);

    // Extract driver's email from the decoded JWT token
    const { email } = req.user;

    // Find the driver based on the email
    const driver = await Driver.findOne({ email });

    if (!driver) {
      return res.status(404).json({ message: 'Driver not found.' });
    }

    // Add driver's information to the ride
    const rideData = {
      ...req.body,
      driver: {
        familyName: driver.familyName,
        firstName: driver.firstName,
        email: driver.email,
        phoneNumber: driver.phoneNumber,
        profileImage: driver.profileImage,
        yearOfBirth:driver.yearOfBirth,
        carData:driver.carData,
      }
    };

    const newRide = new Ride(rideData);
    await newRide.save();
    res.status(200).json({ message: 'Ride added successfully!' });
  } catch (error) {
    console.error(error);
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


///////////////////////////////////////
///////////////////////////////////////
app.get('/api/passengers', async (req, res) => {
  try {
    const passengers = await Passenger.find({});
    res.status(200).json(passengers);
  } catch (error) {
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

app.get('/api/drivers', async (req, res) => {
  try {
    const drivers = await Driver.find({});
    res.status(200).json(drivers);
  } catch (error) {
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

app.get('/api/rides', async (req, res) => {
  try {
    const rides = await Ride.find({});
    res.status(200).json(rides);
  } catch (error) {
    res.status(500).json({ message: 'Internal Server Error' });
  }
});
/////////////////////////////////////////////////////////////////
////////////////// UPDATE EMAIL ////////////////////////////////

app.put('/api/updateEmail', verifyToken, async (req, res) => {
  try {
    const { email } = req.user;
    const { newEmail } = req.body;

    // Update the user's email in the database 
    const user = await Passenger.findOneAndUpdate({ email }, { email: newEmail }, { new: true });

    if (!user) {
      return res.status(404).json({ message: 'User not found.' });
    }

    res.status(200).json({ message: 'Email updated successfully', user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

////////////////// UPDATE PHONE NUMBER ////////////////////////////////

app.put('/api/updatePhoneNumber', verifyToken, async (req, res) => {
  try {
    const { email } = req.user;
    const { newPhoneNumber } = req.body;

    // Update the user's phone number in the database (example)
    const user = await Passenger.findOneAndUpdate({ email }, { phoneNumber: newPhoneNumber }, { new: true });

    if (!user) {
      return res.status(404).json({ message: 'User not found.' });
    }

    res.status(200).json({ message: 'Phone number updated successfully', user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

////////////////////// Add Depannage ////////////////////////////////

app.post('/api/addDepannage', verifyToken, async (req, res) => {
  try {
    console.log(req.body);

    // Extract driver's email from the decoded JWT token
    const { email } = req.user;

    // Find the driver based on the email
    const driver = await Driver.findOne({ email });

    if (!driver) {
      return res.status(404).json({ message: 'Driver not found.' });
    }

    // Add driver's information to the depannage
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
    res.status(200).json({ message: 'Depannage added successfully!' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});

////////////////////// Search Depannage ////////////////////////////////

app.post('/api/searchDepannage', async (req, res) => {
  try {
    const { location } = req.body;

    const depannages = await Depannage.find({ location: location });

    if (depannages.length === 0) {
      return res.status(404).json({ message: 'No depannage found for the specified location.' });
    }

    res.status(200).json({ depannages });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal Server Error' });
  }
});