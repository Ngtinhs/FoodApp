<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Model\Coupon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class CouponController extends Controller
{
    // Get all coupons
    public function index()
    {
        $coupons = Coupon::all();
        return response()->json($coupons);
    }

    // Create a new coupon
    public function insert(Request $request)
    {
        // Validate the request data
        $request->validate([
            'code' => 'required|string|max:50',
            'count' => 'required|integer',
            'promotion' => 'required|integer',
            'description' => 'required|string',
        ]);

        // Create a new coupon
        $coupon = new Coupon;
        $coupon->code = $request->code;
        $coupon->count = $request->count;
        $coupon->promotion = $request->promotion;
        $coupon->description = $request->description;
        $coupon->save();

        return response()->json($coupon, 201);
    }

    // Update a coupon
    public function update(Request $request, $id)
    {
        // Validate the request data
        $request->validate([
            'code' => 'string|max:50',
            'count' => 'integer',
            'promotion' => 'integer',
            'description' => 'string',
        ]);

        // Find the coupon
        $coupon = Coupon::find($id);

        if (!$coupon) {
            return response()->json(['message' => 'Coupon not found'], 404);
        }

        // Update the coupon
        $coupon->code = $request->code ?? $coupon->code;
        $coupon->count = $request->count ?? $coupon->count;
        $coupon->promotion = $request->promotion ?? $coupon->promotion;
        $coupon->description = $request->description ?? $coupon->description;
        $coupon->save();

        return response()->json($coupon);
    }

    // Delete a coupon
    public function delete($id)
    {
        // Find the coupon
        $coupon = Coupon::find($id);

        if (!$coupon) {
            return response()->json(['message' => 'Coupon not found'], 404);
        }

        // Delete the coupon
        $coupon->delete();

        return response()->json(['message' => 'Coupon deleted']);
    }
}