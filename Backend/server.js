var express = require('express')
var app = express()
var mongodb = require('mongodb')
var assert = require('assert')
var db = require('./mongoose')  
const mongodb_URI = process.env.mongodb_URI || 'mongodb+srv://pangj130:Jonathan3388@cluster0.cxem9.mongodb.net/FundraiserApp?retryWrites=true&w=majority'
app.use(express.json())

// /GET all users
app.get('/users/Jonathan338833&&', (req, res) => {
    mongodb.connect(mongodb_URI, function (error, db) {
        if (error) throw error;
        var dbo = db.db('StudentApp')
        dbo.collection('Users').find({}).toArray(function(error, result) {
            if (error) throw error
            res.send(result)
            db.close()
        })
    })
})

const port = process.env.PORT || 2000
app.listen(port, () => console.log('Listening on ' + port + '...'))