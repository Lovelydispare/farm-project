import { ref, computed } from 'vue'
import { defineStore } from 'pinia'

export const useUsersStore = defineStore('users',  {
   state: () => {
        const users = {
            0:{
                id: 1,
                firstname: "Patrick",
                lastname: "Jane",
                email: "patrick32jane@gmail.com",
                phonenumber: "0721635006",
                location: "Nairobi",
                address: "598, Lusaka Road",
            },
             1:{
                id: 2,
                firstname: "Teressa",
                lastname: "Lisbon",
                email: "teressa98lisbon@gmail.com",
                phonenumber: "0721387003",
                location: "Narok",
                address: "345, Narok Road",
            },
             2:{
                id: 3,
                firstname: "Ken",
                lastname: "Kaneki",
                email: "kaneki446ken@gmail.com",
                phonenumber: "0707662875",
                location: "Japan",
                address: "789, Osaka Road",
            },
             3:{
                id: 4,
                firstname: "Touka",
                lastname: "Kirishima",
                email: "kirishima9touka@gmail.com",
                phonenumber: "0712665471",
                location: "Japan",
                address: "4443, Shibuya Road",
            },
             4:{
                id: 5,
                firstname: "Telvin",
                lastname: "Mburu",
                email: "tb3052@gmail.com",
                phonenumber: "0707123456",
                location: "Mombasa",
                address: "203, Kwale Road",
            },
             5:{
                id: 6,
                firstname: "Jaison",
                lastname: "Laurence",
                email: "jaisonlau456rence@gmail.com",
                phonenumber: "0757434567",
                location: "Moyale",
                address: "674, Ole Toktok Road"
            }
            
        }

        return{
            users
        }
   },
   actions:{
      addUser(payload) {
            //get the last key in the users object
            const existingKeys = Object.keys(this.users).map(Number);
            const maxKey = existingKeys.length > 0 ? Math.max(...existingKeys) : 0;
            const nextKey = maxKey + 1;

            //insert into object
            this.users[nextKey] = {
                ...payload,
                id: nextKey
            };
        },
        editUser(id, payload) {
            // find the book in the object
            const user = Object.entries(this.users).find(
                ([key, item]) => item.id === id //compare the ids
            );

            if (!user) {
                console.error(`No user found with id: ${id}`);
                return;
            }

            const [objectKey] = user;

            //replace the existing user data with what was received in payload
            this.users[objectKey] = {
                ...this.users[objectKey], 
                ...payload
            };
        },
        deleteUser(id) {
            const user = Object.entries(this.users).find(
                ([key, item]) => item.id === id
            );
            if (!user) {
                console.error(`Cannot delete: No user found id: ${id}`);
                return;
            }

            const [objectKey] = user;

            delete this.users[objectKey];
        }
      
   },
   persist: true,
})