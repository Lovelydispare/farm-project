<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use App\Models\Role;
use App\Models\User;


class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'firstname' => 'required|string',
            'lastname' => 'required|string',
            'email' => 'required|string|unique:users',
            'phone' => 'required|string',
            'location' => 'required|string',
            'address' => 'required|string',
            'password' => 'required|string|min:8',
        ]);
        try {
            $user = new User();
            $user->firstname = $validated['firstname'];
            $user->lastname = $validated['lastname'];
            $user->email = $validated['email'];
            $user->password = Hash::make($validated['password']);
            $user->role_id = 2;
            $user->phone = $validated['phone'];
            $user->address = $validated['address'];
            $user->location = $validated['location'];

            $user->save();

            $token = $user->createToken('auth-token')->plainTextToken;
            return response()->json([
                'message' => 'Registration Successful!',
                'user' => $user,
                'token' => $token,
            ], 201);
        } catch (\Exception $exception) {
            return response()->json([
                "Error" => "Registration failed: ",
                $exception
            ], 500);
        }
    }

    public function login(Request $request){
        $validated=$request->validate([
            'email'=>'required|email',
            'password'=>'required|string|min:3|max:15',
        ]);

        $user = User::where('email', $validated['email'])->first();

        if(!$user || !Hash::check($validated['password'], $user->password)){
            throw ValidationException::withMessages([
                'error'=>'Invalid Credentials'
            ], 401);
        }

        $token = $user->createToken('auth-token')->plainTextToken;
        return response()->json([
                'message' => 'Login Successful!',
                'user' => $user,
                'token' => $token,
            ], 201);
    }

    public function logout(Request $request){
        $request->user()->currentAccessToken()->delete();
        return response()->json("Logout Successful");
    }
}
