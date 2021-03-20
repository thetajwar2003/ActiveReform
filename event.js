const { Double } = require('mongodb')
const mongoose = require('mongoose')
const Schema = mongoose.Schema

const eventSchema = new Schema ({
    id: {
        type: String,
        required: String
    },
    namesOfContributors: {
        type: [String],
        required: true
    },
    nameOfEvent: {
        type: String,
        required: true
    },
    description: {
        type: String,
        require: false
    },
    money: {
        type: Double,
        required: true 
    },
    tags: {
        type: [String],
        require: true
    }, 
    type: {
        type: String,
        require: true
    }
})

const Events = mongoose.model('Events', eventSchema)
module.exports = Events