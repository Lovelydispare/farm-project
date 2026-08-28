<script setup>

</script>

<template>
    <v-container max-width="100%">
        <v-row>
            <v-col>
                <v-carousel 
                hide-delimiters
                :show-arrows = false
                cycle>
                    <v-carousel-item src="/home1.jpg" cover ></v-carousel-item>
                    <v-carousel-item src="/home2.jpg" cover></v-carousel-item>
                    <v-carousel-item src="/home3.jpg" cover></v-carousel-item>
                    <v-carousel-item src="/home4.jpg" cover></v-carousel-item>
                </v-carousel>
            </v-col>
        </v-row>
    </v-container>
<!-- About Us -->
 <v-container class="bg-secondary" max-width="100%">
    <v-row>
        <v-col class="text-center">
            <div class="text-display-medium mb-12" > Welcome to Shamba Online!</div>
            <div class="text-title-large font-weight-light text-medium-emphasis mb-8 text-white">This is your ultimate happy place for books and stories! We believe finding your next great read should be as fun and easy as turning a page. That is why we have filled our digital shelves with everything from gripping African fiction to inspiring self-help, all ready to ship straight to your door. At Soma, we are just a bunch of book lovers on a mission to spark your curiosity and make reading fit perfectly into your busy life.</div>
            <div class="text-title-large font-weight-light text-medium-emphasis mb-8 text-white">Getting your hands on your favorite titles should never be a hassle. With our super easy online shopping, secure checkout, and lightning-fast delivery across Kenya, your next adventure is always just a few clicks away! Whether you are diving into a thrilling mystery, studying for big goals, or picking out a bedtime story for the kids, Soma is here to make your literary journey bright, easy, and totally delightful.</div>
        </v-col>
    </v-row>
 </v-container>

<!-- Offers -->
 <v-container max-width="100%">
    <v-row>
        <v-col md="3">
            <v-card height="100%" class="d-flex flex-column"> 
                <v-img src="/strawberry.jpg" cover></v-img>
                <v-card-title>Strawberry</v-card-title>
                <v-card-subtitle>Ksh 206 per kg</v-card-subtitle>
                <v-spacer></v-spacer>
                <v-btn to="/product_detail" color="primary">View</v-btn>
            </v-card>
        </v-col>
        <v-col md="3">
            <v-card height="100%" class="d-flex flex-column">
                <v-img src="/tomato.jpg" cover></v-img>
                <v-card-title>Tomatos</v-card-title>
                <v-card-subtitle>Ksh 149 per kg</v-card-subtitle>
                 <v-spacer></v-spacer>
                <v-btn to="/product_detail" color="primary">View</v-btn>
            </v-card>
        </v-col>
        <v-col md="3">
            <v-card height="100%" class="d-flex flex-column">
                <v-img src="/bellpepper.jpg" cover></v-img>
                <v-card-title>Yellow and Red Bell Peppers</v-card-title>
                <v-card-subtitle>Ksh 399 per kg</v-card-subtitle>
                <v-spacer></v-spacer>
                <v-btn to="/product_detail" color="primary">View</v-btn>
            </v-card>
        </v-col>
        <v-col md="3">
            <v-card height="100%" class="d-flex flex-column">
                <v-img src="/sweetpotato.jpg" cover></v-img>
                <v-card-title> Sweet Potato</v-card-title>
                <v-card-subtitle>Ksh 169 per kg</v-card-subtitle>
                 <v-spacer></v-spacer>
                <v-btn to="/product_detail" color="primary">View</v-btn>
            </v-card>
        </v-col>
    </v-row>
 </v-container>

 <!-- Footer -->
  <v-container class="bg-primary" max-width="100%">
    <v-row>
        <v-col>
            <div align="center">
                <router-link to="/">
                    <v-img src="/logo.png" width="50%" height="50%" ></v-img>
                </router-link>

                <p> Copyright Shamba Online &copy; 2026</p>
            </div>
        </v-col>
        <v-col md="4" >
            <div class="text-center">
                <p>Follow us on:</p>
                <v-icon icon="mdi-instagram"></v-icon>
                <v-icon icon="mdi-twitter"></v-icon>
                <v-icon icon="mdi-facebook"></v-icon>
            </div>
        </v-col>
        <v-col md="4">
            <div class="text-center">
                <p> Contact Us:</p>
                <p>Email: info@shambaonline.com</p>
                <p>Phone: 254712345789</p>
            </div>
        </v-col>
    </v-row>
  </v-container>
</template>