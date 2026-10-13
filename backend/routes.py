from flask import Blueprint, jsonify, request
import mysql.connector
import datetime

host = "localhost"
user = "hci_novice"
password = "strongpass!#"
database = "HCI_db"

connection = mysql.connector.connect(
    host=host,
    user=user,
    password=password,
    database=database
)

# Create a blueprint with the URL prefix of "hci_api"
hci_blueprint = Blueprint('hci_api', __name__, url_prefix='/hci_api')



@hci_blueprint.route('/insert_user' , methods=['POST'])
# This function will be called when a POST request is sent to the /insert_user endpoint
def insert_user():
    # Get the request body data
    data = request.json
    # Create a cursor to execute the SQL query
    cursor = connection.cursor()
    # Create the SQL query
    insert_query = "INSERT INTO users (user_id, username, passwd, firstname, surname, email) VALUES (0, %s, %s, %s, %s, %s);"
    try:
        # First check if username or email exists, and if they do return message user already exists 
        sql = "SELECT * FROM users WHERE username = %s OR email = %s;"
        cursor.execute(sql, (data['username'], data['email']))
        results = cursor.fetchall()
        if len(results) > 0:
            # Avoid duplicate usernames or emails
            return jsonify({'message': 'User already exists'}), 400
        # Execute the query
        cursor.execute(insert_query, (data['username'], data['password'], data['firstname'], data['surname'], data['email']))
        # Commit the changes
        connection.commit()
        # Close the cursor
        cursor.close()
        # Return a success message
        return jsonify({'message': 'User created successfully'}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error creating user', 'error': e}), 400
    

    
@hci_blueprint.route('/login', methods=['POST'])
# This function will be called when a POST request is sent to the /login endpoint
def login():
    # Get the request body data
    data = request.json
    # Create a cursor to execute the SQL query
    cursor = connection.cursor()
    # Create the SQL query
    sql = "SELECT * FROM users WHERE username = %s AND passwd = %s;"
    try:
        # Execute the query
        cursor.execute(sql, (data['username'], data['password']))
        # Get the results
        results = cursor.fetchall()
        # Close the cursor
        cursor.close()
        if results is None or len(results) == 0:
            # User does not exist
            # Return an error message
            return jsonify({'message': 'Error logging in'}), 400
        # Return the results
        return jsonify({'message': 'User logged in successfully', 'results': results}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error logging in', 'error': e}), 400
    
@hci_blueprint.route('/get_scans', methods=['POST'])
# This function will be called when a POST request is sent to the /get_scans endpoint
def get_scans():
    # Get the request body data
    data = request.json
    # Create a cursor to execute the SQL query
    cursor = connection.cursor()
    # Create the SQL query
    sql = "SELECT * FROM scans WHERE username = %s;"
    try:
        # Execute the query
        cursor.execute(sql, (data['username'],))
        # Get the results
        results = cursor.fetchall()
        # Close the cursor
        cursor.close()
        if results is None or len(results) == 0:
            # User does not exist
            # Return an error message
            return jsonify({'message': 'Error getting scans'}), 400
        # column_names = [i[0] for i in cursor.description]
        # results = [dict(zip(column_names, row)) for row in results]
        # Return the results
        return jsonify({'message': 'Scans retrieved successfully', 'results': results}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error getting scans', 'error': e}), 400
    
# Write an endpoint to return the total number of scans for a given user
@hci_blueprint.route('/get_num_scans', methods=['POST'])
# This function will be called when a POST request is sent to the /get_num_scans endpoint
def get_num_scans():
    # Get the request body data
    data = request.json
    # Create a cursor to execute the SQL query
    cursor = connection.cursor()
    # Create the SQL query
    sql = "SELECT COUNT(*) FROM scans WHERE username = %s;"
    try:
        # Execute the query
        cursor.execute(sql, (data['username'],))
        # Get the results
        results = cursor.fetchall()
        # Close the cursor
        cursor.close()
        if results is None or len(results) == 0:
            # User does not exist
            # Return an error message
            return jsonify({'message': 'Error getting number of scans'}), 400
        # Return the results
        return jsonify({'message': 'Number of scans retrieved successfully', 'results': results}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error getting number of scans', 'error': e}), 400
    
# Write an endpoint to return the total number of reviews for a given user
@hci_blueprint.route('/get_num_reviews', methods=['POST'])
# This function will be called when a POST request is sent to the /get_num_reviews endpoint
def get_num_reviews():
    # Get the request body data
    data = request.json
    # Create a cursor to execute the SQL query
    cursor = connection.cursor()
    # Create the SQL query
    sql = "SELECT COUNT(*) FROM reviews WHERE username = %s;"
    try:
        # Execute the query
        cursor.execute(sql, (data['username'],))
        # Get the results
        results = cursor.fetchall()
        # Close the cursor
        cursor.close()
        if results is None or len(results) == 0:
            # User does not exist
            # Return an error message
            return jsonify({'message': 'Error getting number of reviews'}), 400
        # Return the results
        return jsonify({'message': 'Number of reviews retrieved successfully', 'results': results}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error getting number of reviews', 'error': e}), 400
    
# Write an endpoint to return the total number of points for a given user
@hci_blueprint.route('/get_sage_points', methods=['POST'])
# This function will be called when a POST request is sent to the /get_num_points endpoint
def get_num_points():
    # Get the request body data
    data = request.json
    # Create a cursor to execute the SQL query
    cursor = connection.cursor()
    # Create the SQL query
    sql = "SELECT sage_points FROM users WHERE username = %s;"
    try:
        # Execute the query
        cursor.execute(sql, (data['username'],))
        # Get the results
        results = cursor.fetchall()
        # Close the cursor
        cursor.close()
        if results is None or len(results) == 0:
            # User does not exist
            # Return an error message
            return jsonify({'message': 'Error getting number of points'}), 400
        # Return the results
        return jsonify({'message': 'Number of points retrieved successfully', 'results': results}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error getting number of points', 'error': e}), 400
    
# Write an endpoint to return all the reviews for a given username
@hci_blueprint.route('/get_reviews_of_user', methods=['POST'])
# This function will be called when a POST request is sent to the /get_reviews endpoint
def get_reviews_of_user():
    # Get the request body data
    data = request.json
    # Create a cursor to execute the SQL query
    cursor = connection.cursor()
    # Create the SQL query
    sql = "SELECT * FROM reviews WHERE username = %s;"
    try:
        # Execute the query
        cursor.execute(sql, (data['username'],))
        # Get the results
        results = cursor.fetchall()
        # Close the cursor
        cursor.close()
        if results is None or len(results) == 0:
            # User does not exist
            # Return an error message
            return jsonify({'message': 'Error getting reviews'}), 400
        # Return the results
        return jsonify({'message': 'Reviews retrieved successfully', 'results': results}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error getting reviews', 'error': e}), 400
    
# Write an endpoint to return all usernames and points, and order by points descending as well as 
# returning the calling user's position in the leaderboard
@hci_blueprint.route('/get_leaderboard', methods=['POST'])
def get_leaderboard():
    data = request.json
    username = data.get('username')  # Get the username from the request data
    cursor = connection.cursor(buffered=True, dictionary=True)
    sql = """
        SELECT username, sage_points, 
        FIND_IN_SET( sage_points, ( SELECT GROUP_CONCAT( sage_points ORDER BY sage_points DESC ) FROM users ) ) AS rank 
        FROM users 
        ORDER BY rank;
    """
    try:
        cursor.execute(sql)
        results = cursor.fetchall()
        cursor.close()
        if results is None or len(results) == 0:
            return jsonify({'message': 'Error getting leaderboard'}), 400

        results2 = [[item['username'], item['sage_points'], item['rank']] for item in results]
        user_rank = next((item for item in results if item["username"] == username), None)  # Find the user's rank
        if user_rank is None:
            return jsonify({'message': 'User not found in leaderboard'}), 400

        return jsonify({
            'message': 'Leaderboard retrieved successfully', 
            'results': results2, 
            'user_rank': user_rank['rank'],  # Return the user's rank
            'user_points': user_rank['sage_points']  # Return the user's points
        }), 200
    except Exception as e:
        print(e)
        return jsonify({'message': 'Error getting leaderboard', 'error': str(e)}), 400

@hci_blueprint.route('/get_reviews_of_wine', methods=['POST'])
# This function will be called when a POST request is sent to the /get_reviews endpoint
def get_reviews_of_wine():
    # Get the request body data
    data = request.json
    # Create a cursor to execute the SQL query
    cursor = connection.cursor()
    # Create the SQL query
    sql = """
            SELECT t.review_id, t.review, t.username, t.wine_name, t.posted_on, t.likes, t. score,  CASE WHEN s.username IS NOT NULL THEN 1 ELSE 0 END AS is_liked
            FROM (SELECT *FROM reviews WHERE wine_name = %s) as t
            LEFT JOIN
            (SELECT * FROM likedReviews as l WHERE l.username = %s) as s ON t.review_id = s.review_id;
        """
    try:
        # Execute the query
        cursor.execute(sql, (data['wine_name'],data['username'],))
        # Get the results
        results = cursor.fetchall()
        # Close the cursor
        cursor.close()
        if results is None or len(results) == 0:
            # User does not exist
            # Return an error message
            return jsonify({'message': 'Error getting reviews'}), 400
        # Return the results
        return jsonify({'message': 'Reviews retrieved successfully', 'results': results}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error getting reviews', 'error': e}), 400

@hci_blueprint.route('/like_review', methods=['POST'])
# This function will be called when a POST request is sent to the /get_reviews endpoint
def like_review():
    # Get the request body data
    data = request.json

    # Create a cursor to execute the SQL query
    cursor = connection.cursor()
    # Create the SQL query
    if data['isLiked'] == 1:
        sql = "DELETE FROM likedReviews WHERE review_id = %s AND username = %s;"
    else:
        sql = "INSERT INTO likedReviews(review_id,username) VALUES (%s, %s);"
    try:
        # Execute the query
        cursor.execute(sql, (data['review_id'],data['username'],))
        # Get the results
        # Close the cursor
        cursor.close()
        # Return the results
        return jsonify({'message': 'Review liked successfully'}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error getting reviews', 'error': e}), 400

@hci_blueprint.route('/search_wine', methods=['POST'])
# This function will be called when a POST request is sent to the /get_reviews endpoint
def search_wine():
    # Get the request body data
    data = request.json
    # Create a cursor to execute the SQL query
    cursor = connection.cursor()
    # Create the SQL query
    sql = """
            SELECT * FROM wines WHERE wine_name = %s;
        """
    try:
        # print(data['wine_name'].rstrip('\n'))
        # print(len(data['wine_name'].rstrip('\n')))
        # Execute the query
        cursor.execute(sql, (data['wine_name'].rstrip('\n'),))
        # Get the results
        results = cursor.fetchall()
        # print(results)
        # Close the cursor
        cursor.close()
        if results is None or len(results) == 0:
            # User does not exist
            # Return an error message
            # print('No wines')
            return jsonify({'message': 'Error getting reviews'}), 400
        # Return the results
        # print(results)
        return jsonify({'message': 'Reviews retrieved successfully', 'results': results}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error getting reviews', 'error': e}), 400
    
@hci_blueprint.route('/update_user', methods=['POST'])
# This function will be called when a POST request is sent to the /update_user endpoint
def update_user():
    # Get the request body data
    data = request.json
    
    # Extract the data from the request body
    username = data.get('username')
    password = data.get('password')
    email = data.get('email')
    current_username = data.get('current_username')
    print(username, password, email, current_username)
    
    # Create a cursor to execute the SQL queries
    cursor = connection.cursor()
    
    # Check if the provided username exists in the database
    if username:
        # Create the SQL query to check if the username exists
        check_username_query = "SELECT * FROM users WHERE username = %s;"
        cursor.execute(check_username_query, (username,))
        result = cursor.fetchone()
        if result:
            # Username already exists
            return jsonify({'message': 'Username already exists'}), 400
    
    # Check if the provided email exists in the database
    if email:
        # Create the SQL query to check if the email exists
        check_email_query = "SELECT * FROM users WHERE email = %s;"
        cursor.execute(check_email_query, (email,))
        result = cursor.fetchone()
        if result:
            # Email already exists
            return jsonify({'message': 'Email already exists'}), 400
    
    # Prepare the data and the query
    data = []
    query = "UPDATE users SET "

    if username:
        query += "username = %s, "
        data.append(username)

    if password:
        query += "passwd = %s, "
        data.append(password)

    if email:
        query += "email = %s, "
        data.append(email)

    # Remove the last comma and add the WHERE clause
    query = query[:-2] + " WHERE username = %s;"
    data.append(current_username)

    try:
        # Execute the query
        cursor.execute(query, tuple(data))
        # Commit the changes to the database
        connection.commit()
        # Close the cursor
        cursor.close()
        # Return a success message
        return jsonify({'message': 'User updated successfully'}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error updating user', 'error': e}), 400


# Create an endpoint to add a scan for a wine made by a user
@hci_blueprint.route('/add_scan', methods=['POST'])
def add_scan():
    # Get the request body data
    data = request.json
    
    # Extract the data from the request body
    username = data.get('username')
    wine_name = data.get('wine_name')
    last_view = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    
    # Create a cursor to execute the SQL queries
    cursor = connection.cursor()
    
    # Create the SQL query
    insert_query = "INSERT INTO scans (scan_id, username, wine_name, last_view) VALUES (0, %s, %s, %s);"
    try:
        # Execute the query
        cursor.execute(insert_query, (username, wine_name, last_view))
        # Commit the changes to the database
        connection.commit()
        # Close the cursor
        cursor.close()
        # Return a success message
        return jsonify({'message': 'Scan added successfully'}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error adding scan', 'error': e}), 400
    
# Create an endpoint to add a review for a wine made by a user
@hci_blueprint.route('/add_review', methods=['POST'])
def add_review():
    # Get the request body data
    data = request.json
    
    # Extract the data from the request body
    username = data.get('username')
    wine_name = data.get('wine_name')
    review = data.get('review')
    posted_on = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    likes = 0
    score = data.get('score')
    
    # Create a cursor to execute the SQL queries
    cursor = connection.cursor()
    
    # Create the SQL query
    insert_query = "INSERT INTO reviews (review_id, username, wine_name, review, posted_on, likes, score) VALUES (0, %s, %s, %s, %s, %s, %s);"
    try:
        # Execute the query
        cursor.execute(insert_query, (username, wine_name, review, posted_on, likes, score))
        # Commit the changes to the database
        connection.commit()
        # Also select average score of the reviews for this wine and save it in variable
        sql = "SELECT AVG(score) FROM reviews WHERE wine_name = %s;"
        cursor.execute(sql, (wine_name,))
        results = cursor.fetchall()
        avg_score = results[0][0]
        # Close the cursor
        cursor.close()
        # Return a success message
        return jsonify({'message': 'Review added successfully', 'newScore': avg_score}), 200
    except Exception as e:
        # Return an error message
        return jsonify({'message': 'Error adding review', 'error': e}), 400