const mongoose = require('mongoose')
const Schema = mongoose.Schema

const userSchema = new Schema ({
    id: {
        type: String,
        required: true
    },
    firstName: {
        type: String,
        required: true
    },
    lastName: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    school: {
        type: String,
        require: false
    },
    idOfMade: {
        type: [String], 
        require: true
    },
    idOfSigned: {
        type: [String],
        require: true
    }
})

const Users = mongoose.model('Users', userSchema)
module.exports = Users