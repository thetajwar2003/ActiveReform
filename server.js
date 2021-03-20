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
        var dbo = db.db('FundraiserApp')
        dbo.collection('Users').find({}).toArray(function(error, result) {
            if (error) throw error
            res.send(result)
            db.close()
        })
    })
})

// /GET specific user 
app.get('/users/:email/:password', (req, res) => {
    mongodb.connect(mongodb_URI, function(error, db) {
        if (error) throw error
        var dbo = db.db('FundraiserApp')
        var query = { email: req.params.email, password: req.params.password }
        dbo.collection('Users').find(query).toArray(function(error, result) { 
            if (error) throw error
            res.send(result)
            console.log(result)
            db.close()
        })
    })
})

// /POST new user
app.post('/users/:id/:firstName/:lastName/:email/:password/:school/:idOfMade/:idOfSigned', (req, res) => {
    const user = {
        id: req.body.id,
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        email: req.body.email,
        password: req.body.password,
        school: req.body.school,
        idOfMade: req.body.idOfMade,
        idOfSigned: req.body.idOfSigned
    }

    mongodb.connect(mongodb_URI, function (error, db) {
        if (error) throw error;
        var dbo = db.db('FundraiserApp')
        dbo.collection('Users').insertOne(user, function(error, result) {
            if (error) throw error;
            assert.equal(null, error)
            console.log('Item inserted')
            db.close();
        })
    })
})

// /GET all events
app.get('/events/Jonathan338833&&', (req, res) => {
    mongodb.connect(mongodb_URI, function (error, db) {
        if (error) throw error;
        var dbo = db.db('FundraiserApp')
        dbo.collection('Events').find({}).toArray(function(error, result) {
            if (error) throw error
            res.send(result)
            db.close()
        })
    })
})

// /GET specific event 
app.get('/events/:id', (req, res) => {
    mongodb.connect(mongodb_URI, function(error, db) {
        if (error) throw error
        var dbo = db.db('FundraiserApp')
        var query = { id: req.params.id }
        dbo.collection('Events').find(query).toArray(function(error, result) { 
            if (error) throw error
            res.send(result)
            console.log(result)
            db.close()
        })
    })
})

// /POST new event
app.post('/events/:id/:namesOfContributors/:nameOfEvent/:description/:money/:tags/:type', (req, res) => {
    const user = {
        id: req.body.id,
        namesOfContributors: req.body.namesOfContributors,
        nameOfEvent: req.body.nameOfEvent,
        description: req.body.description,
        money: req.body.money,
        tags: req.body.tags,
        type: req.body.type
    }

    mongodb.connect(mongodb_URI, function (error, db) {
        if (error) throw error;
        var dbo = db.db('FundraiserApp')
        dbo.collection('Events').insertOne(user, function(error, result) {
            if (error) throw error;
            assert.equal(null, error)
            console.log('Item inserted')
            db.close();
        })
    })
})

const port = process.env.PORT || 2000
app.listen(port, () => console.log('Listening on ' + port + '...'))