const mongoose = require('mongoose')
const Schema = mongoose.Schema

const userSchema = new Schema ({
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
    }
})

const Users = mongoose.model('Users', userSchema)
module.exports = Users