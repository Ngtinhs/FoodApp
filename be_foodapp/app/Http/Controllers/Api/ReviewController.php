<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Model\Review;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;
use Carbon\CarbonInterval;

class ReviewController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    // Get all coupons
    public function index()
{
    $reviews = Review::all();

    $transformedReviews = $reviews->map(function ($review) {
        $user = User::find($review->user_id);
        $userName = $user ? $user->name : null;

        $createdAt = Carbon::parse($review->created_at);
        CarbonInterval::setLocale('vi'); // Thiết lập locale tiếng Việt

        $timeAgo = $createdAt->locale('vi')->diffForHumans(); // Sử dụng locale tiếng Việt và tính toán khoảng thời gian

        return [
            'id' => $review->id,
            'product_id' => $review->product_id,
            'user_id' => $userName,
            'comment' => $review->comment,
            'created_at' => $timeAgo,
            'updated_at' => $timeAgo,
        ];
    });

    return response()->json($transformedReviews);
}

    public function create(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'product_id' => 'required|exists:products,id',
            'user_id' => 'required|exists:users,id',
            'comment' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 400);
        }

        $review = new Review();
        $review->product_id = $request->product_id;
        $review->user_id = $request->user_id;
        $review->comment = $request->comment;
        $review->save();

        return response()->json($review, 201);
    }

    public function show($id)
    {
        $review = Review::find($id);

        if (!$review) {
            return response()->json(['error' => 'Review not found'], 404);
        }

        return response()->json($review, 200);
    }

    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'comment' => 'sometimes|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 400);
        }

        $review = Review::find($id);

        if (!$review) {
            return response()->json(['error' => 'Review not found'], 404);
        }

        if ($request->has('comment')) {
            $review->comment = $request->comment;
        }

        $review->save();

        return response()->json($review, 200);
    }

    public function delete($id)
    {
        $review = Review::find($id);

        if (!$review) {
            return response()->json(['error' => 'Review not found'], 404);
        }

        $review->delete();

        return response()->json(['message' => 'Review deleted successfully'], 200);
    }
}
