const app = require('./app');
const db = require('./config/db');

const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.send("Hello world!")
})

app.listen(PORT, ()=>{
    console.log(`Server running on Port: http://localhost:${PORT}`);
});