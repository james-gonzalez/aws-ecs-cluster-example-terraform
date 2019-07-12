import boto3
import uuid
s3_client = boto3.client('s3')
s3_resource = boto3.resource('s3')

def create_temp_file(size, file_name, file_content):
    random_file_name = ''.join([str(uuid.uuid4().hex[:6]), file_name])
    with open(random_file_name, 'w') as f:
        f.write(str(file_content) * size)
    return random_file_name

first_file_name = create_temp_file(300, 'firstfile.txt', 'f')
print('File Name: ' + str(first_file_name))


first_object = s3_resource.Object(
    bucket_name="jamesg-data-test-bucket", key=first_file_name)

print('Uploading: ' + str(first_file_name))
first_object.upload_file(first_file_name)
